//
//  MoEInboxUtils.swift
//  MoEPluginInbox
//
//  Created by Rakshitha on 11/07/22.
//

import Foundation
import MoEngageInbox
import MoEPluginBase

protocol MoEInboxUtils: MoEPluginUtils {
    static func getInboxPayload(inboxMessages: [MOInboxEntry], identifier: String) -> [String: Any]
    static func getUnreadCountPayload(count: Int, identifier: String) -> [String: Any]
    static func getCampaignIdForStats(inboxDict: [String: Any]) -> String?
}

extension MoEInboxUtils {
    
    static func getInboxPayload(inboxMessages: [MOInboxEntry], identifier: String) -> [String: Any] {
        let accountMeta = fetchAccountPayload(identifier: identifier)
        var messages = [[String: Any]]()
        
        for inboxMessage in inboxMessages {
            var message = [String: Any]()
            
            message[MoEPluginConstants.General.campaignId] = inboxMessage.campaignID
            message[MoEPluginConstants.Inbox.text] = getTextPayload(inboxMessage: inboxMessage)
            message[MoEPluginConstants.Inbox.media] = getMediaPayload(inboxMessage: inboxMessage)
            message[MoEPluginConstants.Inbox.isClicked] = inboxMessage.isRead
            message[MoEPluginConstants.Inbox.receivedTime] = inboxMessage.receivedDate
            message[MoEPluginConstants.Inbox.expiry] = inboxMessage.inboxExpiryDate
            message[MoEPluginConstants.General.payload] = inboxMessage.notificationPayloadDict
            message[MoEPluginConstants.Inbox.action] = getActionPayload(inboxMessage: inboxMessage)
            
            messages.append(message)
        }
        
        let data = [MoEPluginConstants.General.platform: MoEPluginConstants.General.iOS, MoEPluginConstants.Inbox.messages: messages] as [String: Any]
        return [MoEPluginConstants.General.accountMeta: accountMeta, MoEPluginConstants.General.data: data]
    }
    
    static func getTextPayload(inboxMessage: MOInboxEntry) -> [String: Any] {
        var textPayload = [String: Any]()
        
        textPayload[MoEPluginConstants.Inbox.title] = inboxMessage.notificationTitle
        textPayload[MoEPluginConstants.Inbox.subtitle] = inboxMessage.notificationSubTitle
        textPayload[MoEPluginConstants.Inbox.message] = inboxMessage.notificationBody
        
        return textPayload
    }
    
    static func getMediaPayload(inboxMessage: MOInboxEntry) -> [String: Any] {
        var mediaPayload = [String: Any]()
        
        let moengageDict = inboxMessage.notificationPayloadDict[MoEPluginConstants.Inbox.moengage] as? [String: Any]
        mediaPayload[MoEPluginConstants.Inbox.type] = moengageDict?[MoEPluginConstants.Inbox.mediaType]
        mediaPayload[MoEPluginConstants.Inbox.url] = inboxMessage.notificationMediaURL
        
        return mediaPayload
    }
    
    static func getActionPayload(inboxMessage: MOInboxEntry) -> [[String: Any]] {
        var actionDict = [[String: Any]]()
        
        if let deepLinkURL = inboxMessage.deepLinkURL, !deepLinkURL.isEmpty {
            var deepLinkAction = [String: Any]()
            
            deepLinkAction[MoEPluginConstants.General.actionType] = MoEPluginConstants.General.navigation
            deepLinkAction[MoEPluginConstants.General.navigationType] = MoEPluginConstants.Inbox.deepLink
            deepLinkAction[MoEPluginConstants.General.value] = deepLinkURL
            deepLinkAction[MoEPluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(deepLinkAction)
        }
        
        if let richLandingURL = inboxMessage.richLandingURL, !richLandingURL.isEmpty {
            var richLandingAction = [String: Any]()
            
            richLandingAction[MoEPluginConstants.General.actionType] = MoEPluginConstants.General.navigation
            richLandingAction[MoEPluginConstants.General.navigationType] = MoEPluginConstants.Inbox.richLanding
            richLandingAction[MoEPluginConstants.General.value] = richLandingURL
            richLandingAction[MoEPluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(richLandingAction)
        }
        
        if let screenName = inboxMessage.screenName, !screenName.isEmpty {
            var navigateToScreenAction = [String: Any]()
            
            navigateToScreenAction[MoEPluginConstants.General.actionType] = MoEPluginConstants.General.navigation
            navigateToScreenAction[MoEPluginConstants.General.navigationType] = MoEPluginConstants.Inbox.screenName
            navigateToScreenAction[MoEPluginConstants.General.value] = screenName
            navigateToScreenAction[MoEPluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(navigateToScreenAction)
        }
        
        return actionDict
    }
    
    static func getUnreadCountPayload(count: Int, identifier: String) -> [String: Any] {
        let accountMeta = fetchAccountPayload(identifier: identifier)
        let data = [MoEPluginConstants.Inbox.unClickedCount: count]
        return [MoEPluginConstants.General.accountMeta: accountMeta, MoEPluginConstants.General.data: data]
    }
    
    static func getCampaignIdForStats(inboxDict: [String: Any]) -> String? {
        if let data = inboxDict[MoEPluginConstants.General.data] as? [String: Any],
           let campaignID = data[MoEPluginConstants.General.campaignId] as? String,
           !campaignID.isEmpty {
            return campaignID
        }
        
        return nil
    }
}
