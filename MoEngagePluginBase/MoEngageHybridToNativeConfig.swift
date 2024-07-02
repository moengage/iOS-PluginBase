//
//  MoEngageHybridToNativeConfig.swift
//  MoEngagePluginBase
//
//  Created by UdayKiran Naik on 02/07/24.
//

import Foundation

public class MoEngageHybridToNativeConfig {
    public static let sharedInstance = MoEngageHybridToNativeConfig()
    private var hybridToNativeConfigCache: [String:MoEngageInitConfig] = [:]
    
    private init() {
        
    }
    
    public func initializeInitConfig(appID: String, initConfig: MoEngageInitConfig) {
        if(hybridToNativeConfigCache.keys.contains(appID)) {
            return
        }
        
        self.hybridToNativeConfigCache[appID] = initConfig
    }
    
    public func fetchShouldTrackUserAttributeBooleanAsNumber(forAppID: String)->Bool {
        guard let initConfig = hybridToNativeConfigCache[forAppID] else {
            return false
        }
        
        return initConfig.analyticsConfig.shouldTrackUserAttributeBooleanAsNumber
    }
    
}
