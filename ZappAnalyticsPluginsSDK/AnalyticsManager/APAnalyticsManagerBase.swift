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
    @objc public private(set) var currentScreenViewTitle:String?
    
    public func clearAnalyticsProviders() {
        analyticsProviders = []
    }
 
    public func prepareManager(currentProvider:(_ provider:ZPAnalyticsProviderProtocol) -> ZPAnalyticsProviderProtocol?, completion:(AnalyticManagerPreparationCompletion)) {
        clearAnalyticsProviders()
        createAnalyticsProviders(currentProvider:currentProvider,
                                 completion: completion)
    }
    
    
    public func createAnalyticsProviders(currentProvider:(_ provider:ZPAnalyticsProviderProtocol) -> ZPAnalyticsProviderProtocol?,
                                         completion:(AnalyticManagerPreparationCompletion)) {
        let pluggableProviders = ZPAnalyticsManager.sharedInstance.getProviders()
        for provider in pluggableProviders {
            if let updatedProvider = currentProvider(provider),
                updatedProvider.configureProvider() {
                analyticsProviders.append(updatedProvider)
            }
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
                let parameters = parameters as? [String:NSObject] ?? [:]

                if let method = provider.trackEvent(_:parameters:model:) {
                    method(name,
                           parameters,
                           model)
                } else {
                    provider.trackEvent(name, parameters: parameters) { (success, logText) in
                        logCompletion(provider, success, logText)
                    }
                }
            }
        }
    }
    
    public func trackEvent(name: String,
                           parameters:  Dictionary<String, Any>?,
                           timed: Bool) {
        let parameters = parameters as? [String:NSObject] ?? [:]
        
        for provider in analyticsProviders {
            if provider.shouldTrackEvent(name) {
                provider.trackEvent?(name,
                                     parameters: parameters,
                                     timed: timed)
            }
        }
    }
    
    @objc open func endTimedEvent(_ eventName: String,
                                  withParameters parameters: [String : Any]?) {
        let parameters = parameters as? [String:NSObject] ?? [:]
        for provider in analyticsProviders {
            if provider.shouldTrackEvent(eventName) {
                provider.endTimedEvent?(eventName,
                                        parameters: parameters)
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

