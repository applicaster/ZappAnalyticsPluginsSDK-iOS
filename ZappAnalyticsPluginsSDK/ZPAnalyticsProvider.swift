//
//  ZPAnalyticsProvider.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 12/07/2016.
//  Copyright © 2016 Applicaster. All rights reserved.
//

import UIKit
import Toaster
import ZappPlugins

//Providers Json Parameters
let kSettingsAnalyticsKey   = "settings"
let kNotApplicableKey  =  "N/A"

@objc open class ZPAnalyticsProvider : NSObject, ZPAnalyticsProviderProtocol {

    open var defaultEventProperties: [String:NSObject]!
    open var genericUserProfile: [String:NSObject]!
    open var providerProperties: [String:NSObject]!
    open var baseProperties: [String:NSObject] = [String:NSObject]()

    open var configurationJSON:NSDictionary?
    
    // used for optional support for timed events implementation
    var timedEventsDictionary: [String: APTimedEvent] = [:]

    lazy var enableLogEventsToasts:Bool = {
        return (self.configurationJSON?["enable_toasts"] as? Bool) ?? false
    }()

    lazy var eventsToastsBackgroundColor:UIColor = {
        var color:UIColor = UIColor(red: 18/255.0, green: 165/255.0, blue: 70/255.0, alpha: 1.0)
        if let colorString = self.configurationJSON?["toasts_bgcolor"] as? String,
            !colorString.isEmpty {
            color = UIColor(hex: colorString)
        }
        return color;
    }()

    lazy var eventsToastsTextColor:UIColor = {
        var color:UIColor = UIColor.white
        if let colorString = self.configurationJSON?["toasts_textcolor"] as? String,
            !colorString.isEmpty {
            color = UIColor(hex: colorString)
        }
        return color;
    }()

    lazy var eventsToastsDuration:TimeInterval = {
        return self.configurationJSON?["toasts_duration"] as? Double ?? 1.5;
    }()

    lazy var blacklistedEvents:[String] = {
        if let events = self.configurationJSON?["blacklisted_events"] as? String {
            return events.components(separatedBy: ";").filter { $0.isEmpty == false }.map { $0.lowercased() }
        }
        else {
            return []
        }
    }()

    open var providerKey:String {
        get {
            return self.getKey()
        }
    }
    public required init(configurationJSON:NSDictionary?) {
        super.init()
        self.configurationJSON = configurationJSON
    }

    public required override init() {
        super.init()
    }

    open func getKey() -> String {
        //implement in child classes
        return ""
    }

    open func setBaseParameter(_ value:NSObject?, forKey key:String) {
        if let value = value {
            self.baseProperties[key] = value
        }
    }

    open func analyticsMaxParametersAllowed() -> Int {
        //implement in child classes
        return -1
    }

    open func updateGenericUserProperties(_ genericUserProperties: [String:NSObject]) {
        self.genericUserProfile = genericUserProperties
    }

    open func updateDefaultEventProperties(_ eventProperties: [String:NSObject]) {
        self.defaultEventProperties = eventProperties
    }

    open func sortPropertiesAlphabeticallyAndCutThemByLimitation(_ properties: [String:NSObject]) -> [String:NSObject] {
        //need to sort alphabetically and take the first analyticsMaxParametersAllowed objects

        let sortedKeys = properties.keys.sorted(by: <)
        var sortedDictionary:[String:NSObject] = [String:NSObject]()

        var objectsNumber: Int = min(self.analyticsMaxParametersAllowed(), sortedKeys.count)

        // No limitation
        if self.analyticsMaxParametersAllowed() < 0 {
            objectsNumber = sortedKeys.count
        }

        for i in 0..<objectsNumber {
            sortedDictionary[sortedKeys[i]] = properties[sortedKeys[i]] as NSObject?
        }

        return sortedDictionary
    }

    open func createAnalyticsProvider(_ allProvidersSetting: [String:NSObject]) -> Bool {

        if let providerDataByKey = allProvidersSetting[self.providerKey] as? [String:NSObject] {
            if let properties = providerDataByKey[kSettingsAnalyticsKey] as? [String:NSObject] {
                self.providerProperties = properties
                return self.configureProvider()
            }
        }
        return false
    }

    open func configureProvider() -> Bool {
        //implement in child classes
        return false
    }

    open func setPushNotificationDeviceToken(_ deviceToken:Data) {
        //implement in child classes
    }

    @objc static open func defaultProperties(_ defaultProperties: [String:NSObject]?, combinedWithEventParams  eventParams: [String:NSObject], shouldIncludeExtraParams: Bool = true) -> [String:NSObject] {
        var properties:[String:NSObject] = [:].merge(eventParams)

        if shouldIncludeExtraParams {
            properties = properties.merge(self.extraDefaultProperties())
        }

        guard let defaultProperties = defaultProperties else {
            //if no def properties return just what is alredy merged
            return properties
        }

        //return merging gathered properties with default properties
        return properties.merge(defaultProperties)
    }

    static func extraDefaultProperties() -> [String:NSObject] {
        var properties:[String:NSObject] = [:]

        //attach current screen name if exists
        if let topViewController = ZAAppConnector.sharedInstance().navigationDelegate.currentViewController() as? ZPAnalyticsScreenProtocol {
            properties["Triggered From"] = topViewController.analyticsScreenName() as NSObject
        }
        return properties
    }

    open func shouldTrackEvent(_ eventName:String) -> Bool {
        return !self.blacklistedEvents.contains(eventName.lowercased())
    }

    open func canPresentToastForLoggedEvents() -> Bool {
        return self.enableLogEventsToasts
    }

    open func presentToastForLoggedEvent(_ eventDescription: String?) {
        guard let desc = eventDescription, !desc.isEmpty else {
            return
        }

        let toast = Toast(text: desc,
                          delay: 0,
                          duration: self.eventsToastsDuration)
        toast.view.backgroundColor = self.eventsToastsBackgroundColor
        toast.view.textColor = self.eventsToastsTextColor
        toast.show()

        ZPAnalyticsProvider.presentToastForLoggedEvent(eventDescription,
                                                       eventsToastsDuration: self.eventsToastsDuration,
                                                       eventsToastsBackgroundColor: self.eventsToastsBackgroundColor,
                                                       eventsToastsTextColor: self.eventsToastsTextColor)
    }

    @objc static open func presentToastForLoggedEvent(_ eventDescription: String?,
                                                      eventsToastsDuration:TimeInterval,
                                                      eventsToastsBackgroundColor:UIColor,
                                                      eventsToastsTextColor:UIColor) {
        guard let desc = eventDescription, !desc.isEmpty else {
            return
        }

        let toast = Toast(text: desc,
                          delay: 0,
                          duration: eventsToastsDuration)
        toast.view.backgroundColor = eventsToastsBackgroundColor
        toast.view.textColor = eventsToastsTextColor
        toast.show()
    }

    @objc static open func parseParameters(fromEventName evenName:String?) -> [String:String] {
        var params:[String:String] = [:]

        guard let evenName = evenName else {
            return params
        }

        let showDelimeter = "Show -"
        if evenName.range(of: showDelimeter) != nil,
            let value = evenName.components(separatedBy: showDelimeter).last?.trimmingCharacters(in: .whitespaces) {
            params["Show Name"] = value
        }

        let seasonDelimeter =  "Season -"
        if evenName.range(of: seasonDelimeter) != nil {
            var array = evenName.components(separatedBy: "-")
            array.removeFirst() //remove "Season" string
            if let seasonName = array.last?.trimmingCharacters(in: .whitespaces) {
                params["Season Name"] = seasonName
                array.removeLast() //remove season name
            }

            let showName = array.joined(separator: "-").trimmingCharacters(in: .whitespaces)
            params["Show Name"] = showName
        }

        return params
    }

    open func trackEvent(_ eventName:String) {
        //implement in child classes
    }

    open func trackCampaignParamsFromUrl(_ url: NSURL) {
        //implement in child classes
    }

    open func trackEvent(_ eventName: String, parameters: [String : NSObject], completion: ((Bool, String?) -> Void)?) {
        self.trackEvent(eventName, parameters: parameters)
        completion?(true, nil)
    }

    open func trackEvent(_ eventName:String, parameters: [String:NSObject]) {
        //implement in child classes
    }

    open func trackEvent(_ eventName:String, message: String, exception:NSException) {
        //implement in child classes
    }

    open func trackEvent(_ eventName:String, message: String, error: NSError) {
        //implement in child classes
    }

    open func trackEvent(_ eventName:String, timed:Bool) {
        //implement in child classes
    }

    open func trackEvent(_ eventName:String, parameters: [String:NSObject], timed:Bool) {
        //implement in child classes
    }

    open func trackEvent(_ eventName:String, action: String, label:String, value:Int) {
        let params:[String:NSObject] = ["action": action as NSObject, "label": label as NSObject, "value": value as NSObject]

        self.trackEvent(eventName, parameters: params)
    }

    open func trackScreenView(_ screenName: String, parameters: [String : NSObject], completion: ((Bool, String?) -> Void)?) {
        self.trackScreenView(screenName, parameters: parameters)
        completion?(true, nil)
    }

    open func trackScreenView(_ screenName:String, parameters: [String:NSObject]) {
        //implement in child classes
    }

    open func endTimedEvent(_ eventName:String, parameters: [String:NSObject]) {
        //implement in child classes
    }

    @available(*, deprecated, message: "Will be not in use starting 'ZappAnalyticsPlugins 0.5.0', use setUserProfile(genericUserProperties, piiUserProperties) instead")
    open func setUserProfile(parameters: [String:NSObject]) {
        //DEPRECATED IN ZappAnalyticsPlugins 0.5.0
    }

    open func setUserProfile(genericUserProperties dictGenericUserProperties: [String:NSObject], piiUserProperties dictPiiUserProperties: [String:NSObject]) {
        //implement in child classes
    }

    open func trackError(_ errorID: String, message: String, exception: NSException) {
        //implement in child classes
    }

    open func trackError(_ errorID: String, message: String, error: NSError) {
        //implement in child classes
    }

    //MARK: Helper Functions

    open func analyticsString(_ dictionary: [String:NSObject]) -> String {
        var retVal = kNotApplicableKey
        var combinedString = ""
        let sortedKeys = dictionary.keys.sorted(by: <)
        for key in sortedKeys {
            if let string = dictionary[key] as? String {
                combinedString += "\(key)=\(string);"
            }
        }

        if combinedString.count > 0 {
            retVal = String(combinedString.dropLast())
        }

        return retVal
    }

    @objc static open func getFirebaseRemoteConfigurationParameters(prefix: String, baseProperties: [String:NSObject]) -> [String:NSObject] {

        var dictRetValue:[String:NSObject] = [String:NSObject]()
        let dictParametersSources = self.getParametersForMatchingWithFirebaseRemoteConfigurationKeys(baseProperties)

        if let firebaseDelegate = ZAAppConnector.sharedInstance().firebaseRemoteConfigurationDelegate,
            let firebaseRemoteKeys = firebaseDelegate.keys(withPrefix: prefix) {
            for remoteKey in Array(firebaseRemoteKeys) {
                if let remoteValue = firebaseDelegate.string(forKey: remoteKey) {
                    if dictParametersSources.keys.contains(remoteValue) {
                        //save the new value for key from matching source
                        dictRetValue[remoteKey] = dictParametersSources[remoteValue]
                    }
                    else {
                        dictRetValue[remoteKey] = kNotApplicableKey as NSObject
                    }
                }
            }
        }
        return dictRetValue
    }

    @objc static open func getParametersForMatchingWithFirebaseRemoteConfigurationKeys(_ baseProperties: [String:NSObject]) -> [String:NSObject] {
        var dictRetValue:[String:NSObject] = [String:NSObject]()

        if let dictBroadcasterExtensions = baseProperties[kBroadcasterExtensionsInternalParam] as? [String:NSObject] {
            for (key, value) in dictBroadcasterExtensions {
                dictRetValue[key] = value
            }
        }

        let params = ZPFirebaseRemoteConfigurationManager.sharedInstance.getParametersForMatchingWithRemoteConfigurationKeys()
        for (key, value) in params {
            dictRetValue[key] = value as? NSObject
        }

        return dictRetValue
    }
}
