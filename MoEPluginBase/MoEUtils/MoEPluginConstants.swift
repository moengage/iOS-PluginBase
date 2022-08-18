//
//  MoEPluginConstants.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation

public struct MoEPluginConstants {
    
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
        static let type = "type"
        static let appId = "appId"
        static let campaignName = "campaignName"
        static let event = "event"
        static let message = "message"
    }
    
    // user attribute
    struct UserAttribute {
        static let alias = "alias"
        static let type = "type"
        static let attributeName = "attributeName"
        static let attributeValue = "attributeValue"
        static let locationAttribute = "locationAttribute"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let general = "general"
        static let timestamp = "timestamp"
        static let location = "location"
    }
    
    // event
    struct EventTracking {
        static let eventName = "eventName"
        static let eventAttributes = "eventAttributes"
        static let isNonInteractive = "isNonInteractive"
    }
    
    // OptOuts
    struct SDKState {
       static let isSdkEnabled = "isSdkEnabled"
       static let state = "state"
       static let data = "data"
    }
    
    struct AppStatus {
        static let appStatus = "appStatus"
        static let install = "INSTALL"
        static let update = "UPDATE"
    }
    
    struct InApp {
        static let contexts = "contexts"
        static let impression = "impression"
        static let click = "click"
        static let dismissed = "dismissed"
        static let campaignContext = "campaignContext"
        static let dismissInterval = "dismissInterval"
        static let selfHandled = "selfHandled"
        static let customAction = "customAction"
        static let screen = "screen"
        static let campaignId = "campaignId"
        static let campaignName = "campaignName"
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
    
    // Inbox
    public struct Inbox {
        public static let unClickedCount = "unClickedCount"
        public static let title = "title"
        public static let subtitle = "subtitle"
        public static let message = "message"
        public static let text = "text"
        public static let type = "type"
        public static let url = "url"
        public static let media = "media"
        public static let isClicked = "isClicked"
        public static let receivedTime = "receivedTime"
        public static let expiry = "expiry"
        public static let action = "action"
        public static let messages = "messages"
        public static let moengage = "moengage"
        public static let mediaType = "media-type"
        public static let deepLink = "deepLink"
        public static let richLanding = "richLanding"
        public static let screenName = "screenName"
    }

}
