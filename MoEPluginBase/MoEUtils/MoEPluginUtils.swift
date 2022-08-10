//
//  MoEPluginUtils.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageInApps
import MoEngageSDK

public protocol MoEPluginUtils: class {
    static func fetchIdentifier(attribute: [String: Any]) -> String?
    static func fetchAccountPayload(identifier: String) -> [String: Any]
    static func fetchInAppPayload(inAppCampaign: MOInAppCampaign, inAppAction: MOInAppAction?, identifier: String) -> [String: Any]
    static func fetchSelfHandledPayload(selfHandledCampaign: MOInAppSelfHandledCampaign?, identifier: String) -> [String: Any]
    static func fetchTokenPayload(deviceToken: String) -> [String: Any]
    static func fetchPushClickedPayload(withScreenName screenName: String?, kvPairs: [AnyHashable: Any]?, andPushPayload userInfo: [AnyHashable: Any], identifier: String) -> [String: Any]
}

extension MoEPluginUtils {
    
    // MARK: General Utilities
    public static func fetchIdentifier(attribute: [String: Any]) -> String? {
        if let accountMeta = attribute[MoEPluginConstants.General.accountMeta] as? [String: Any],
           let appID = accountMeta[MoEPluginConstants.General.appId] as? String,
           !appID.isEmpty {
            return appID
        }
        
        if let defaultSDK = MoEngage.sharedInstance().getDefaultSDKConfiguration() {
            return defaultSDK.identifier
        }
        
        return nil
    }
    
    public static func fetchAccountPayload(identifier: String) -> [String: Any] {
        let appIdDict = [MoEPluginConstants.General.appId: identifier]
        return appIdDict
    }
    
    // MARK: InApp Utilities
    public static func fetchInAppPayload(inAppCampaign: MOInAppCampaign, inAppAction: MOInAppAction? = nil, identifier: String) -> [String: Any] {
        let accountMeta = fetchAccountPayload(identifier: identifier)
        
        var inAppDataPayload = inAppCampaign.fetchInAppPaylaod()
        
        if let inAppAction = inAppAction {
            let actionPayload = inAppAction.fetchInAppActionPayload()
            
            if inAppAction.actionType == NavigationAction {
                inAppDataPayload[MoEPluginConstants.General.actionType] = MoEPluginConstants.General.navigation
                inAppDataPayload[MoEPluginConstants.General.navigation] = actionPayload
            } else if inAppAction.actionType == CustomAction {
                inAppDataPayload[MoEPluginConstants.General.actionType] = MoEPluginConstants.InApp.customAction
                inAppDataPayload[MoEPluginConstants.InApp.customAction] = actionPayload
            }
        }
        
        let inAppPayload = [MoEPluginConstants.General.accountMeta: accountMeta, MoEPluginConstants.General.data: inAppDataPayload]
        return inAppPayload
    }
    
    public static func fetchSelfHandledPayload(selfHandledCampaign: MOInAppSelfHandledCampaign?, identifier: String) -> [String: Any] {
        var inAppPayload = [String: Any]()
        
        let accountMeta = fetchAccountPayload(identifier: identifier)
        
        var inAppDataPayload = [String: Any]()
        
        if let selfHandledCampaign = selfHandledCampaign {
            inAppDataPayload = selfHandledCampaign.fetchInAppPaylaod()
            
            var selfHandledPayload = [String: Any]()
            selfHandledPayload[MoEPluginConstants.General.payload] = selfHandledCampaign.campaignContent
            selfHandledPayload[MoEPluginConstants.InApp.dismissInterval] = selfHandledCampaign.autoDismissInterval
            inAppDataPayload[MoEPluginConstants.InApp.selfHandled] = selfHandledPayload
        }
        
        inAppPayload = [MoEPluginConstants.General.accountMeta: accountMeta, MoEPluginConstants.General.data: inAppDataPayload]
        return inAppPayload
    }
    
    // MARK: Push Utilities
    public static func fetchTokenPayload(deviceToken: String) -> [String: Any] {
        let tokenPayload = [MoEPluginConstants.General.platform: MoEPluginConstants.General.iOS, MoEPluginConstants.Push.pushService: MoEPluginConstants.Push.APNS, MoEPluginConstants.Push.token: deviceToken]
        return tokenPayload
    }
    
    public static func fetchPushClickedPayload(withScreenName screenName: String?, kvPairs: [AnyHashable: Any]?, andPushPayload userInfo: [AnyHashable: Any], identifier: String) -> [String: Any] {
        
        var actionPayloadDict = [String: Any]()
        if let screenName = screenName, !screenName.isEmpty {
            actionPayloadDict[MoEPluginConstants.General.type] = MoEPluginConstants.Push.screenName
            actionPayloadDict[MoEPluginConstants.General.value] = screenName
        }
        
        if let kvPairs = kvPairs, !kvPairs.isEmpty {
            actionPayloadDict[MoEPluginConstants.General.kvPair] = kvPairs
        }
        
        var clickedActionDict = [String: Any]()
        if !actionPayloadDict.isEmpty {
            clickedActionDict[MoEPluginConstants.General.type] = MoEPluginConstants.General.navigation
            clickedActionDict[MoEPluginConstants.General.payload] = actionPayloadDict
        }
        
        let data = [MoEPluginConstants.General.platform: MoEPluginConstants.General.iOS, MoEPluginConstants.General.payload: userInfo, MoEPluginConstants.Push.clickedAction: clickedActionDict] as [String: Any]
        
        let accountMeta = fetchAccountPayload(identifier: identifier)
        let payload = [MoEPluginConstants.General.data: data, MoEPluginConstants.General.accountMeta: accountMeta]
        return payload
    }
}

extension MOInAppCampaign {
    func fetchInAppPaylaod() -> [String: Any] {
        let inAppPayload = [MoEPluginConstants.General.campaignName: campaign_name, MoEPluginConstants.General.campaignId: campaign_id, MoEPluginConstants.InApp.campaignContext: campaign_context, MoEPluginConstants.General.platform: MoEPluginConstants.General.iOS] as [String: Any]
        return inAppPayload
    }
}

extension MOInAppAction {
    func fetchInAppActionPayload() -> [String: Any] {
        var actionPayload = [String: Any]()
        
        if actionType == NavigationAction {
            actionPayload[MoEPluginConstants.General.navigationType] = MoEPluginConstants.InApp.screen
        }
        
        if !screenName.isEmpty {
            actionPayload[MoEPluginConstants.General.value] = screenName
        }
        
        if !keyValuePairs.isEmpty {
            actionPayload[MoEPluginConstants.General.kvPair] = keyValuePairs
        }
        
        return actionPayload
    }
}

extension MOInAppSelfHandledCampaign {
    
    convenience init(campaignPayload: [String: Any]) {
        self.init()
        
        if let campaign_id = campaignPayload[MoEPluginConstants.InApp.campaignId] as? String {
            self.campaign_id = campaign_id
        }
        
        if let campaign_name = campaignPayload[MoEPluginConstants.InApp.campaignName] as? String {
            self.campaign_name = campaign_name
        }
        
        if let campaign_context = campaignPayload[MoEPluginConstants.InApp.campaignContext] as? [String: Any] {
            self.campaign_context = campaign_context
        }
    }
}
