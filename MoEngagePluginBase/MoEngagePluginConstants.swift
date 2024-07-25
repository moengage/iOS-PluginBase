//
//  MoEngagePluginConstants.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation

public struct MoEngagePluginConstants {
    
    private init() {
    }
    
    struct SDKVersions {
        static let currentVersion = "8.3.0"
        static let minimumVersion = "8.3.0"
        static let maximumVersion = "8.4.0"
    }
    
    public struct General {
        public static let accountMeta = "accountMeta"
        public static let data = "data"
        public static let campaignId = "campaignId"
        public static let platform = "platform"
        public static let iOS = "iOS"
        public static let kvPair = "kvPair"
        public static let value = "value"
        public static let navigation = "navigation"
        public static let payload = "payload"
        public static let navigationType = "navigationType"
        public static let actionType = "actionType"
        public static let type = "type"
        public static let initConfig = "initConfig"
        static let appId = "appId"
        static let campaignName = "campaignName"
        static let event = "event"
        static let message = "message"
        static let integrationMeta = "integrationMeta"
        static let integrationType = "type"
        static let integrationVersion = "version"
        public static let analyticsConfig = "analyticsConfig"
        public static let shouldTrackUserAttributeBooleanAsNumber = "shouldTrackUserAttributeBooleanAsNumber"
    }
    
    // user attribute
    public struct UserAttribute {
        static let alias = "alias"
        public static let type = "type"
        public static let attributeName = "attributeName"
        public static let attributeValue = "attributeValue"
        public static let locationAttribute = "locationAttribute"
        public static let latitude = "latitude"
        public static let longitude = "longitude"
        public static let general = "general"
        public static let timestamp = "timestamp"
        public static let location = "location"
    }
    
    // event
    struct EventTracking {
        static let eventName = "eventName"
        static let eventAttributes = "eventAttributes"
        static let isNonInteractive = "isNonInteractive"
    }
    
    // OptOuts
    public struct SDKState {
        public static let isSdkEnabled = "isSdkEnabled"
        public static let state = "state"
        public static let data = "data"
    }
    
    struct AppStatus {
        static let appStatus = "appStatus"
        static let install = "INSTALL"
        static let update = "UPDATE"
    }
    
    public struct InApp {
        public static let contexts = "contexts"
        public static let impression = "impression"
        public static let click = "click"
        public static let dismissed = "dismissed"
        public static let campaignContext = "campaignContext"
        static let dismissInterval = "dismissInterval"
        public static let selfHandled = "selfHandled"
        public static let customAction = "customAction"
        static let screen = "screen"
        static let deeplink = "deep_linking"
        static let campaignId = "campaignId"
        static let campaignName = "campaignName"
        static let position = "position"
        
        enum NudgePosition: String {
            case top, bottom, bottomLeft, bottomRight, any
        }
    }
    
    // Push
    struct Push {
        static let pushService = "pushService"
        static let APNS = "APNS"
        static let token = "token"
        static let screenName = "screenName"
        static let clickedAction = "clickedAction"
    }
    
    // Callback
    public struct CallBackEvents {
        public static let inAppShown = "MoEInAppCampaignShown"
        public static let inAppDismissed = "MoEInAppCampaignDismissed"
        public static let inAppClicked = "MoEInAppCampaignClicked"
        public static let inAppCustomAction = "MoEInAppCampaignCustomAction"
        public static let inAppSelfHandled = "MoEInAppCampaignSelfHandled"
        public static let pushTokenGenerated = "MoEPushTokenGenerated"
        public static let pushClicked = "MoEPushClicked"
    }
    
    struct ExternalPluginBase {
        static let cardsBridge = "MoEngagePluginCards.MoEngagePluginCardsDelegateHandler"
    }
}
