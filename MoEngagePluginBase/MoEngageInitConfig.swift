//
//  MoEngageInitConfig.swift
//  MoEngagePluginBase
//
//  Created by UdayKiran Naik on 02/07/24.
//

import Foundation

public class MoEngageInitConfig {
    var analyticsConfig: MoEngageAnalyticsConfig
    
    public init(analyticsConfig: MoEngageAnalyticsConfig) {
        self.analyticsConfig = analyticsConfig
    }
}
