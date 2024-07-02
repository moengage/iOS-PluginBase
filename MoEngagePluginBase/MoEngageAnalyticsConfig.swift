//
//  MoEngageAnalyticsConfig.swift
//  MoEngagePluginBase
//
//  Created by UdayKiran Naik on 02/07/24.
//

import Foundation

public class MoEngageAnalyticsConfig {
    var shouldTrackUserAttributeBooleanAsNumber: Bool
    
    public init(shouldTrackUserAttributeBooleanAsNumber: Bool) {
        self.shouldTrackUserAttributeBooleanAsNumber = shouldTrackUserAttributeBooleanAsNumber
    }
}
