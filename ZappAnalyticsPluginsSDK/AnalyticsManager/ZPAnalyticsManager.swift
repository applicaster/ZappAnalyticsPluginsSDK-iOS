//
//  ZPAnalyticsManager.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 12/07/2016.
//  Copyright © 2016 Applicaster Ltd. All rights reserved.
//

import ZappPlugins

@objc public class ZPAnalyticsManager: NSObject {
    @objc public static let sharedInstance = ZPAnalyticsManager()
    
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    /**
     private method - Get providers types from Zapp
     */
    @objc public func getProviders() -> [ZPAnalyticsProviderProtocol] {
        var providers = [ZPAnalyticsProviderProtocol]()
        let pluginModels = ZPPluginManager.pluginModels()?.filter { $0.pluginType == .Analytics }
        if let pluginModels = pluginModels  {
            for pluginModel in pluginModels {
                if let classType = ZPPluginManager.adapterClass(pluginModel) as? ZPAnalyticsProviderProtocol.Type {
                    let provider = classType.init(configurationJSON: pluginModel.configurationJSON)
                    providers.append(provider)
                }
            }
        }
        
        return providers
    }
}
