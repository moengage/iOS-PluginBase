//
//  MoEngagePluginParser.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 09/08/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

protocol MoEngagePluginParser {
    static func optOutDataTracking(dataTrack: [String: Any]) -> (String, Bool)?
    static func setAppStatus(appStatus: [String: Any]) -> AppStatus?
    static func setAlias(alias: [String: Any]) -> String?
    static func setUserAttribute(userAttribute: [String: Any]) -> (String, String, Any?)?
    static func trackEvent(eventAttribute: [String: Any]) -> (String, MOProperties)?
    static func setInAppContext(context: [String: Any]) -> [String]?
    static func updateSelfHandledImpression(inApp: [String: Any]) -> (MOInAppSelfHandledCampaign, String)?
}

extension MoEngagePluginParser {
    static func optOutDataTracking(dataTrack: [String: Any]) -> (String, Bool)? {
        guard let dataDict = dataTrack[MoEngagePluginConstants.General.data] as? [String: Any],
              let type = dataDict[MoEngagePluginConstants.General.type] as? String,
              let state = dataDict[MoEngagePluginConstants.SDKState.state] as? Bool
        else {
            return nil
        }
        
        return (type, state)
    }
    
    static func setAppStatus(appStatus: [String: Any]) -> AppStatus? {
        if let dataDict = appStatus[MoEngagePluginConstants.General.data] as? [String: Any],
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
    
    static func setAlias(alias: [String: Any]) -> String? {
        guard let dataDict = alias[MoEngagePluginConstants.General.data] as? [String: Any],
              let aliasValue = dataDict[MoEngagePluginConstants.UserAttribute.alias] as? String,
              !aliasValue.isEmpty
        else {
            return nil
        }
        
        return aliasValue
    }
    
    static func setUserAttribute(userAttribute: [String: Any]) -> (String, String, Any?)? {
        guard let dataDict = userAttribute[MoEngagePluginConstants.General.data] as? [String: Any],
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
        
        return (type, attributeName, attributeValue)
    }
    
    static func trackEvent(eventAttribute: [String: Any]) -> (String, MOProperties)? {
        guard let dataDict = eventAttribute[MoEngagePluginConstants.General.data] as? [String: Any],
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
        return(eventName, properties)
    }
    
    static func setInAppContext(context: [String: Any]) -> [String]? {
        guard let dataDict = context[MoEngagePluginConstants.General.data] as? [String: Any],
              let contexts = dataDict[MoEngagePluginConstants.InApp.contexts] as? [String]
        else {
            return nil
        }
        
        return contexts
    }
    
    static func updateSelfHandledImpression(inApp: [String: Any]) -> (MOInAppSelfHandledCampaign, String)? {
        guard let dataDict = inApp[MoEngagePluginConstants.General.data] as? [String: Any],
              let impressionType = dataDict[MoEngagePluginConstants.General.type] as? String
        else {
            return nil
        }
        
        let selfHandledCampaign = MOInAppSelfHandledCampaign(campaignPayload: dataDict)
        return (selfHandledCampaign, impressionType)
    }
    
    static func updateSDKState(sdkState: [String: Any]) -> Bool? {
        guard let dataDict = sdkState[MoEngagePluginConstants.General.data] as? [String: Any],
              let sdkState = dataDict[MoEngagePluginConstants.SDKState.isSdkEnabled] as? Bool
        else {
            return nil
        }
        
        return sdkState
    }
}
