//
//  MoEPluginParser.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 09/08/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

protocol MoEPluginParser: class {
    static func optOutDataTracking(dataTrack: [String: Any]) -> (String, Bool)?
    static func setAppStatus(appStatus: [String: Any]) -> AppStatus?
    static func setAlias(alias: [String: Any]) -> String?
    static func setUserAttribute(userAttribute: [String: Any]) -> (String, String, Any?)?
    static func trackEvent(eventAttribute: [String: Any]) -> (String, MOProperties)?
    static func setInAppContext(context: [String: Any]) -> [String]?
    static func updateSelfHandledImpression(inApp: [String: Any]) -> (MOInAppSelfHandledCampaign, String)?
}

extension MoEPluginParser {
    static func optOutDataTracking(dataTrack: [String: Any]) -> (String, Bool)? {
        guard let dataDict = dataTrack[MoEPluginConstants.General.data] as? [String: Any],
              let type = dataDict[MoEPluginConstants.General.type] as? String,
              let state = dataDict[MoEPluginConstants.SDKState.state] as? Bool
        else {
            return nil
        }
        
        return (type, state)
    }
    
    static func setAppStatus(appStatus: [String: Any]) -> AppStatus? {
        if let dataDict = appStatus[MoEPluginConstants.General.data] as? [String: Any],
           let appStatus = dataDict[MoEPluginConstants.AppStatus.appStatus] as? String,
           !appStatus.isEmpty {
            
            switch appStatus {
            case MoEPluginConstants.AppStatus.install:
                return .install
            case MoEPluginConstants.AppStatus.update:
                return .update
            default:
                break
            }
        }
        
        return nil
    }
    
    static func setAlias(alias: [String: Any]) -> String? {
        guard let dataDict = alias[MoEPluginConstants.General.data] as? [String: Any],
              let aliasValue = dataDict[MoEPluginConstants.UserAttribute.alias] as? String,
              !aliasValue.isEmpty
        else {
            return nil
        }
        
        return aliasValue
    }
    
    static func setUserAttribute(userAttribute: [String: Any]) -> (String, String, Any?)? {
        guard let dataDict = userAttribute[MoEPluginConstants.General.data] as? [String: Any],
              let type = dataDict[MoEPluginConstants.General.type] as? String,
              let attributeName = dataDict[MoEPluginConstants.UserAttribute.attributeName] as? String
        else {
            return nil
        }
        
        var attributeValue = dataDict[MoEPluginConstants.UserAttribute.attributeValue]
        
        if let locationAttributeDict = dataDict[MoEPluginConstants.UserAttribute.locationAttribute] as? [String: Any],
           let latitude = locationAttributeDict[MoEPluginConstants.UserAttribute.latitude] as? Double,
           let longitude = locationAttributeDict[MoEPluginConstants.UserAttribute.longitude] as? Double {
            attributeValue = MOGeoLocation(withLatitude: latitude, andLongitude: longitude)
        }
        
        return (type, attributeName, attributeValue)
    }
    
    static func trackEvent(eventAttribute: [String: Any]) -> (String, MOProperties)? {
        guard let dataDict = eventAttribute[MoEPluginConstants.General.data] as? [String: Any],
              let eventName = dataDict[MoEPluginConstants.EventTracking.eventName] as? String
        else {
            return nil
        }
        
        var eventAttributeDict = dataDict[MoEPluginConstants.EventTracking.eventAttributes] as? [String: Any]
        if let isNonInteractive = dataDict[MoEPluginConstants.EventTracking.isNonInteractive] as? Bool {
            eventAttributeDict?[MoEPluginConstants.EventTracking.isNonInteractive] = isNonInteractive
        }
        
        let properties = MOProperties()
        properties.updateAttributes(withPluginPayload: eventAttributeDict)
        return(eventName, properties)
    }
    
    static func setInAppContext(context: [String: Any]) -> [String]? {
        guard let dataDict = context[MoEPluginConstants.General.data] as? [String: Any],
              let contexts = dataDict[MoEPluginConstants.InApp.contexts] as? [String]
        else {
            return nil
        }
        
        return contexts
    }
    
    static func updateSelfHandledImpression(inApp: [String: Any]) -> (MOInAppSelfHandledCampaign, String)? {
        guard let dataDict = inApp[MoEPluginConstants.General.data] as? [String: Any],
              let impressionType = dataDict[MoEPluginConstants.General.type] as? String
        else {
            return nil
        }
        
        let selfHandledCampaign = MOInAppSelfHandledCampaign(campaignPayload: dataDict)
        return (selfHandledCampaign, impressionType)
    }
    
    static func updateSDKState(sdkState: [String: Any]) -> Bool? {
        guard let dataDict = sdkState[MoEPluginConstants.General.data] as? [String: Any],
              let sdkState = dataDict[MoEPluginConstants.SDKState.isSdkEnabled] as? Bool
        else {
            return nil
        }
        
        return sdkState
    }
}
