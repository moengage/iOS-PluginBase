//
//  MoEngageSegmentPluginParser.swift
//  MoEngageSegmentPluginBase
//
//  Created by Rakshitha on 09/05/23.
//

import Foundation
import MoEngageSDK

class MoEngageSegmentPluginParser {
    
    static func fetchAlias(payload: [String: Any]) -> String? {
        guard let dataDict = payload[MoEngageSegmentPluginConstants.General.data] as? [String: Any],
              let aliasValue = dataDict[MoEngageSegmentPluginConstants.UserAttribute.alias] as? String,
              !aliasValue.isEmpty
        else {
            return nil
        }
        
        return aliasValue
    }
    
    static func fetchAnonymousId(payload: [String: Any]) -> String? {
        guard let dataDict = payload[MoEngageSegmentPluginConstants.General.data] as? [String: Any],
              let id = dataDict[MoEngageSegmentPluginConstants.UserAttribute.anonymousId] as? String,
              !id.isEmpty
        else {
            return nil
        }
        
        return id
    }
    
    static func fetchEventProperties(payload: [String: Any]) -> MoEngageProperties {
        let moeProperties = MoEngageProperties()
        
        if let properties = payload[MoEngageSegmentPluginConstants.EventTracking.properties] as? [String: Any] {
            for (key, value) in properties {
                if let epochDate = MoEngageSegmentPluginUtils.fetchEpochDateFromString(value: value) {
                    moeProperties.addDateAttribute(epochDate, withName: key)
                } else {
                    moeProperties.addAttribute(value, withName: key)
                }
            }
        }
        
        return moeProperties
    }
    
}
