//
//  MoEngagePluginParser.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 09/08/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

class MoEngagePluginParser {
    static func mapJsonToOptOutData(payload: [String: Any]) -> MoEngagePluginOptOutData? {
        guard let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
              let type = dataDict[MoEngagePluginConstants.General.type] as? String,
              let state = dataDict[MoEngagePluginConstants.SDKState.state] as? Bool
        else {
            return nil
        }
        
        return MoEngagePluginOptOutData(type: type, value: state)
    }
    
    static func fetchAppStatus(payload: [String: Any]) -> AppStatus? {
        if let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
           let appStatus = dataDict[MoEngagePluginConstants.AppStatus.appStatus] as? String,
           !appStatus.isEmpty {
            
            switch appStatus {
            case MoEngagePluginConstants.AppStatus.install:
                return .install
            case MoEngagePluginConstants.AppStatus.update:
                return .update
            default:
                break
            }
        }
        
        return nil
    }
    
    static func fetchAlias(payload: [String: Any]) -> String? {
        guard let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
              let aliasValue = dataDict[MoEngagePluginConstants.UserAttribute.alias] as? String,
              !aliasValue.isEmpty
        else {
            return nil
        }
        
        return aliasValue
    }
    
    static func mapJsonToUserAttributeData(payload: [String: Any]) -> MoEngagePluginUserAttributeData? {
        guard let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
              let type = dataDict[MoEngagePluginConstants.General.type] as? String,
              let attributeName = dataDict[MoEngagePluginConstants.UserAttribute.attributeName] as? String
        else {
            return nil
        }
        
        var attributeValue = dataDict[MoEngagePluginConstants.UserAttribute.attributeValue]
        
        if let locationAttributeDict = dataDict[MoEngagePluginConstants.UserAttribute.locationAttribute] as? [String: Any],
           let latitude = locationAttributeDict[MoEngagePluginConstants.UserAttribute.latitude] as? Double,
           let longitude = locationAttributeDict[MoEngagePluginConstants.UserAttribute.longitude] as? Double {
            attributeValue = MOGeoLocation(withLatitude: latitude, andLongitude: longitude)
        }
        
        if let value = attributeValue {
            return MoEngagePluginUserAttributeData(name: attributeName, value: value, type: type)
        }
        
        return nil
    }
    
    static func mapJsonToEventData(payload: [String: Any]) -> MoEngagePluginEventData? {
        guard let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
              let eventName = dataDict[MoEngagePluginConstants.EventTracking.eventName] as? String
        else {
            return nil
        }
        
        var eventAttributeDict = dataDict[MoEngagePluginConstants.EventTracking.eventAttributes] as? [String: Any]
        if let isNonInteractive = dataDict[MoEngagePluginConstants.EventTracking.isNonInteractive] as? Bool {
            eventAttributeDict?[MoEngagePluginConstants.EventTracking.isNonInteractive] = isNonInteractive
        }
        
        let properties = MOProperties()
        properties.updateAttributes(withPluginPayload: eventAttributeDict)
        return MoEngagePluginEventData(name: eventName, properties: properties)
    }
    
    static func fetchContextData(payload: [String: Any]) -> [String]? {
        guard let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
              let contexts = dataDict[MoEngagePluginConstants.InApp.contexts] as? [String]
        else {
            return nil
        }
        
        return contexts
    }
    
    static func mapJsonToSelfHandledImpressionData(payload: [String: Any]) -> MoEngagePluginSelfHandledImpressionData? {
        guard let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
              let impressionType = dataDict[MoEngagePluginConstants.General.type] as? String
        else {
            return nil
        }
        
        let selfHandledCampaign = MOInAppSelfHandledCampaign(campaignPayload: dataDict)
        return MoEngagePluginSelfHandledImpressionData(selfHandledCampaign: selfHandledCampaign, impressionType: impressionType)
    }

    static func fetchSDKState(payload: [String: Any]) -> Bool? {
        guard let dataDict = payload[MoEngagePluginConstants.General.data] as? [String: Any],
              let sdkState = dataDict[MoEngagePluginConstants.SDKState.isSdkEnabled] as? Bool
        else {
            return nil
        }
        
        return sdkState
    }

}
