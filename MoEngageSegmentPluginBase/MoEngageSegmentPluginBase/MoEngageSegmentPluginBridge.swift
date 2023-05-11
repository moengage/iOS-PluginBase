//
//  MoEngageSegmentPluginBridge.swift
//  MoEngageSegmentPluginBase
//
//  Created by Rakshitha on 09/05/23.
//

import Foundation
import MoEngageSDK

@objc final public class MoEngageSegmentPluginBridge: NSObject {

    @objc public static let sharedInstance = MoEngageSegmentPluginBridge()
    
    private override init() {
    }
    
    @objc public func trackAnonymousId(_ payload: [String: Any]) {
        if let identifier = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: payload),
           let id = MoEngageSegmentPluginParser.fetchAnonymousId(payload: payload) {
            MoEngageSDKAnalytics.sharedInstance.setUserAttribute(id, withAttributeName: MoEngageSegmentPluginConstants.UserAttribute.segmentId, forAppID: identifier)
        }
    }
    
    @objc public func setAlias(_ payload: [String: Any]) {
        if let identifier = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: payload),
           let alias = MoEngageSegmentPluginParser.fetchAlias(payload: payload) {
            MoEngageSDKAnalytics.sharedInstance.setAlias(alias, forAppID: identifier)
        }
    }
    
    @objc public func setUserAttribute(_ payload: [String: Any]) {
        guard let identifier = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: payload),
              let dataDict = payload[MoEngageSegmentPluginConstants.General.data] as? [String: Any],
              let traits = dataDict[MoEngageSegmentPluginConstants.UserAttribute.traits] as? [String: Any]
        else {
            return
        }
        
        for (attributeName, attributeValue) in traits {
            if let epochDate = MoEngageSegmentPluginUtils.fetchEpochDateFromString(value: attributeValue) {
                
                MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(epochDate, withAttributeName: attributeName, forAppID: identifier)
                
            } else if let location = attributeValue as? [String: Any] {
                if let latitute = location[MoEngageSegmentPluginConstants.UserAttribute.latitude] as? Double, let longitude = location[MoEngageSegmentPluginConstants.UserAttribute.longitude] as? Double {
                    
                    MoEngageSDKAnalytics.sharedInstance.setLocation(MoEngageGeoLocation(withLatitude: latitute, andLongitude: longitude), forAppID: identifier)
                    
                }
            } else {
                
                MoEngageSDKAnalytics.sharedInstance.setUserAttribute(attributeValue, withAttributeName: attributeName, forAppID: identifier)
                
            }
        }
    }
    
    @objc public func trackEvent(_ payload: [String: Any]) {
        guard let identifier = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: payload),
              let dataDict = payload[MoEngageSegmentPluginConstants.General.data] as? [String: Any],
              let eventName = dataDict[MoEngageSegmentPluginConstants.EventTracking.event] as? String
        else {
            return
        }
        
        let moeProperties = MoEngageSegmentPluginParser.fetchEventProperties(payload: dataDict)
        
        MoEngageSDKAnalytics.sharedInstance.trackEvent(eventName, withProperties: moeProperties, forAppID: identifier)
    }

    
    @objc public func resetUser(_ payload: [String: Any]) {
        if let identifier = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: payload) {
            MoEngageSDKAnalytics.sharedInstance.resetUser(forAppID: identifier)
        }
    }
}
