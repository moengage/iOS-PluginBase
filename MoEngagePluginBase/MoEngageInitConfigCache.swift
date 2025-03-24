//
//  MoEngageHybridToNativeConfig.swift
//  MoEngagePluginBase
//
//  Created by UdayKiran Naik on 02/07/24.
//

import Foundation
import MoEngageCore

public class MoEngageInitConfigCache {
    public static let sharedInstance = MoEngageInitConfigCache()
    private var initConfigCache: [String:MoEngageInitConfig] = [:]
    
    private init() {
        
    }
    
    func initializeInitConfig(appID: String, initConfig: MoEngageInitConfig) {
        MoEngageCoreHandler.globalQueue.async {
            if(self.initConfigCache.keys.contains(appID)) {
                return
            }
            
            self.initConfigCache[appID] = initConfig
        }
    }
    
    func fetchShouldTrackUserAttributeBooleanAsNumber(forAppID: String, completionHandler: @escaping(Bool) -> Void) {
        MoEngageCoreHandler.globalQueue.async {
            guard let initConfig = self.initConfigCache[forAppID] else {
                completionHandler(false)
                return
            }
            
            completionHandler(initConfig.analyticsConfig.shouldTrackUserAttributeBooleanAsNumber)
        }
    }
}
