//
//  APAnalyticsManagerBase.swift
//  ZappAnalyticsPluginsSDK
//
//  Created by Anton Kononenko on 11/22/18.
//  Copyright © 2018 Applicaster. All rights reserved.
//

import Foundation
import ZappPlugins

public typealias AnalyticManagerPreparationCompletion = () -> Void
public typealias ProviderSendAnalyticsCompletion = (_ provider:ZPAnalyticsProviderProtocol, _ success:Bool, _ logText:String?) -> Void
@objc open class APAnalyticsManageBase:NSObject {
    @objc public var analyticsProviders:[ZPAnalyticsProviderProtocol] = []
    var currentScreenViewTitle:String?
    
    public func prepareManager(completion:(AnalyticManagerPreparationCompletion)) {
        clearAnalyticsProviders()
        createAnalyticsProviders(completion: completion)
    }
    
    public func clearAnalyticsProviders() {
        analyticsProviders = []
    }
    
    public func createAnalyticsProviders(completion:(AnalyticManagerPreparationCompletion)) {
        let pluggableProviders = ZPAnalyticsManager.sharedInstance.getProviders()
        
        for provider in pluggableProviders {
            analyticsProviders.append(provider)
        }
        completion()
    }
    
    public func trackEvent(name: String, parameters: [String: Any]?, logCompletion:@escaping ProviderSendAnalyticsCompletion) {
        trackEvent(name: name,
                   parameters: parameters,
                   model: nil,
                   logCompletion:logCompletion)
    }

    public func trackEvent(name: String, parameters: [String: Any]?, model:NSObject?, logCompletion:@escaping ProviderSendAnalyticsCompletion) {
        for provider in analyticsProviders {
            if provider.shouldTrackEvent(name) {
                if let method = provider.trackEvent(_:parameters:model:) {
                    let parameters = parameters as? [String:NSObject] ?? [:]
                    method(name,
                           parameters,
                           model)
                } else {
                    let parameters = parameters as? [String:NSObject] ?? [:]
                    provider.trackEvent?(name, parameters: parameters) { (success:Bool, logText:String) in
                        logCompletion(provider, success, logText)
                    }
                }
            }
        }
    }
    
    public func trackScreenView(screenTitle: String, parameters: [String: Any]?, logCompletion:@escaping ProviderSendAnalyticsCompletion) {
        if currentScreenViewTitle != screenTitle {
            var parameters = parameters as? [String:NSObject] ?? [:]
            parameters["Trigger"] = NSString(string: screenTitle)
            for provider in analyticsProviders {
                if provider.shouldTrackEvent(screenTitle) {
                    provider.trackScreenView(screenTitle, parameters: parameters) { (success, logText) in
                        logCompletion(provider, success, logText)
                    }
                }
            }
            currentScreenViewTitle = screenTitle
        }
    }
}

