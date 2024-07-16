//
//  MoEngageHybridToNativeConfig.swift
//  MoEngagePluginBase
//
//  Created by UdayKiran Naik on 02/07/24.
//

import Foundation

public class MoEngageInitConfigCache {
    public static let sharedInstance = MoEngageInitConfigCache()
    private var initConfigCache: [String:MoEngageInitConfig] = [:]
    
    private init() {
        
    }
    
    func initializeInitConfig(appID: String, initConfig: MoEngageInitConfig) {
        if(initConfigCache.keys.contains(appID)) {
            return
        }
        
        self.initConfigCache[appID] = initConfig
    }
    
    func fetchShouldTrackUserAttributeBooleanAsNumber(forAppID: String)->Bool {
        guard let initConfig = initConfigCache[forAppID] else {
            return false
        }
        
        return initConfig.analyticsConfig.shouldTrackUserAttributeBooleanAsNumber
    }
    
}
