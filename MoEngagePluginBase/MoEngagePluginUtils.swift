//
//  MoEngagePluginUtils.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageInApps
import MoEngageSDK

public class MoEngagePluginUtils {
    
    // MARK: General Utilities
    static public func fetchIdentifierFromPayload(attribute: [String: Any]) -> String? {
        if let accountMeta = attribute[MoEngagePluginConstants.General.accountMeta] as? [String: Any],
           let appID = accountMeta[MoEngagePluginConstants.General.appId] as? String,
           !appID.isEmpty {
            return appID
        }
        
        return nil
    }
    
    static public func createAccountPayload(identifier: String) -> [String: Any] {
        let appIdDict = [MoEngagePluginConstants.General.appId: identifier]
        return appIdDict
    }
    
    // MARK: InApp Utilities
    static func inAppCampaignToJSON(inAppCampaign: MOInAppCampaign, inAppAction: MOInAppAction? = nil, identifier: String) -> [String: Any] {
        let accountMeta = createAccountPayload(identifier: identifier)
        
        var inAppDataPayload = inAppCampaign.fetchInAppPaylaod()
        
        if let inAppAction = inAppAction {
            let actionPayload = inAppAction.fetchInAppActionPayload()
            
            if inAppAction.actionType == NavigationAction {
                inAppDataPayload[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.General.navigation
                inAppDataPayload[MoEngagePluginConstants.General.navigation] = actionPayload
            } else if inAppAction.actionType == CustomAction {
                inAppDataPayload[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.InApp.customAction
                inAppDataPayload[MoEngagePluginConstants.InApp.customAction] = actionPayload
            }
        }
        
        let inAppPayload = [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: inAppDataPayload]
        return inAppPayload
    }
    
    static func selfHandledCampaignToJSON(selfHandledCampaign: MOInAppSelfHandledCampaign?, identifier: String) -> [String: Any] {
        var inAppPayload = [String: Any]()
        
        let accountMeta = createAccountPayload(identifier: identifier)
        
        var inAppDataPayload = [String: Any]()
        
        if let selfHandledCampaign = selfHandledCampaign {
            inAppDataPayload = selfHandledCampaign.fetchInAppPaylaod()
            
            var selfHandledPayload = [String: Any]()
            selfHandledPayload[MoEngagePluginConstants.General.payload] = selfHandledCampaign.campaignContent
            selfHandledPayload[MoEngagePluginConstants.InApp.dismissInterval] = selfHandledCampaign.autoDismissInterval
            inAppDataPayload[MoEngagePluginConstants.InApp.selfHandled] = selfHandledPayload
        }
        
        inAppPayload = [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: inAppDataPayload]
        return inAppPayload
    }
    
    // MARK: Push Utilities
    static func createTokenPayload(deviceToken: String) -> [String: Any] {
        let tokenPayload = [MoEngagePluginConstants.General.platform: MoEngagePluginConstants.General.iOS, MoEngagePluginConstants.Push.pushService: MoEngagePluginConstants.Push.APNS, MoEngagePluginConstants.Push.token: deviceToken]
        return tokenPayload
    }
    
    static func createPushClickPayload(withScreenName screenName: String?, kvPairs: [AnyHashable: Any]?, andPushPayload userInfo: [AnyHashable: Any], identifier: String) -> [String: Any] {
        
        var actionPayloadDict = [String: Any]()
        if let screenName = screenName, !screenName.isEmpty {
            actionPayloadDict[MoEngagePluginConstants.General.type] = MoEngagePluginConstants.Push.screenName
            actionPayloadDict[MoEngagePluginConstants.General.value] = screenName
        }
        
        if let kvPairs = kvPairs, !kvPairs.isEmpty {
            actionPayloadDict[MoEngagePluginConstants.General.kvPair] = kvPairs
        }
        
        var clickedActionDict = [String: Any]()
        if !actionPayloadDict.isEmpty {
            clickedActionDict[MoEngagePluginConstants.General.type] = MoEngagePluginConstants.General.navigation
            clickedActionDict[MoEngagePluginConstants.General.payload] = actionPayloadDict
        }
        
        let data = [MoEngagePluginConstants.General.platform: MoEngagePluginConstants.General.iOS, MoEngagePluginConstants.General.payload: userInfo, MoEngagePluginConstants.Push.clickedAction: clickedActionDict] as [String: Any]
        
        let accountMeta = createAccountPayload(identifier: identifier)
        let payload = [MoEngagePluginConstants.General.data: data, MoEngagePluginConstants.General.accountMeta: accountMeta]
        return payload
    }
}

extension MOInAppCampaign {
    func fetchInAppPaylaod() -> [String: Any] {
        let inAppPayload = [MoEngagePluginConstants.General.campaignName: campaign_name, MoEngagePluginConstants.General.campaignId: campaign_id, MoEngagePluginConstants.InApp.campaignContext: campaign_context, MoEngagePluginConstants.General.platform: MoEngagePluginConstants.General.iOS] as [String: Any]
        return inAppPayload
    }
}

extension MOInAppAction {
    func fetchInAppActionPayload() -> [String: Any] {
        var actionPayload = [String: Any]()
        
        if actionType == NavigationAction {
            actionPayload[MoEngagePluginConstants.General.navigationType] = MoEngagePluginConstants.InApp.screen
        }
        
        if !screenName.isEmpty {
            actionPayload[MoEngagePluginConstants.General.value] = screenName
        }
        
        if !keyValuePairs.isEmpty {
            actionPayload[MoEngagePluginConstants.General.kvPair] = keyValuePairs
        }
        
        return actionPayload
    }
}

extension MOInAppSelfHandledCampaign {
    
    convenience init(campaignPayload: [String: Any]) {
        self.init()
        
        if let campaign_id = campaignPayload[MoEngagePluginConstants.InApp.campaignId] as? String {
            self.campaign_id = campaign_id
        }
        
        if let campaign_name = campaignPayload[MoEngagePluginConstants.InApp.campaignName] as? String {
            self.campaign_name = campaign_name
        }
        
        if let campaign_context = campaignPayload[MoEngagePluginConstants.InApp.campaignContext] as? [String: Any] {
            self.campaign_context = campaign_context
        }
    }
}
