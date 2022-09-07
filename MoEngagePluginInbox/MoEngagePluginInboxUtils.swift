//
//  MoEngagePluginInboxUtils.swift
//  MoEPluginInbox
//
//  Created by Rakshitha on 11/07/22.
//

import Foundation
import MoEngageInbox
import MoEngagePluginBase
import MoEngageSDK

protocol MoEngagePluginInboxUtils: MoEngagePluginUtils {
    static func getInboxPayload(inboxMessages: [MOInboxEntry], identifier: String) -> [String: Any]
    static func getUnreadCountPayload(count: Int, identifier: String) -> [String: Any]
    static func getCampaignIdForStats(inboxDict: [String: Any]) -> String?
}

extension MoEngagePluginInboxUtils {
    
    static func getInboxPayload(inboxMessages: [MOInboxEntry], identifier: String) -> [String: Any] {
        let accountMeta = fetchAccountPayload(identifier: identifier)
        var messages = [[String: Any]]()
        
        for inboxMessage in inboxMessages {
            var message = [String: Any]()
            
            message[MoEngagePluginConstants.General.campaignId] = inboxMessage.campaignID
            message[MoEngagePluginConstants.Inbox.text] = getTextPayload(inboxMessage: inboxMessage)
            message[MoEngagePluginConstants.Inbox.media] = getMediaPayload(inboxMessage: inboxMessage)
            message[MoEngagePluginConstants.Inbox.isClicked] = inboxMessage.isRead
            message[MoEngagePluginConstants.Inbox.receivedTime] = MODateUtils.getString(forDate: inboxMessage.receivedDate, withFormat:MOCoreConstants.DateTimeFormats.iso8601, andForGMTTimeZone: true)
            message[MoEngagePluginConstants.Inbox.expiry] = MODateUtils.getString(forDate: inboxMessage.inboxExpiryDate, withFormat:MOCoreConstants.DateTimeFormats.iso8601, andForGMTTimeZone: true)
            message[MoEngagePluginConstants.General.payload] = inboxMessage.notificationPayloadDict
            message[MoEngagePluginConstants.Inbox.action] = getActionPayload(inboxMessage: inboxMessage)
            
            messages.append(message)
        }
        
        let data = [MoEngagePluginConstants.General.platform: MoEngagePluginConstants.General.iOS, MoEngagePluginConstants.Inbox.messages: messages] as [String: Any]
        return [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: data]
    }
    
    static func getTextPayload(inboxMessage: MOInboxEntry) -> [String: Any] {
        var textPayload = [String: Any]()
        
        textPayload[MoEngagePluginConstants.Inbox.title] = inboxMessage.notificationTitle
        textPayload[MoEngagePluginConstants.Inbox.subtitle] = inboxMessage.notificationSubTitle
        textPayload[MoEngagePluginConstants.Inbox.message] = inboxMessage.notificationBody
        
        return textPayload
    }
    
    static func getMediaPayload(inboxMessage: MOInboxEntry) -> [String: Any] {
        var mediaPayload = [String: Any]()
        
        let moengageDict = inboxMessage.notificationPayloadDict[MoEngagePluginConstants.Inbox.moengage] as? [String: Any]
        mediaPayload[MoEngagePluginConstants.Inbox.type] = moengageDict?[MoEngagePluginConstants.Inbox.mediaType]
        mediaPayload[MoEngagePluginConstants.Inbox.url] = inboxMessage.notificationMediaURL
        
        return mediaPayload
    }
    
    static func getActionPayload(inboxMessage: MOInboxEntry) -> [[String: Any]] {
        var actionDict = [[String: Any]]()
        
        if let deepLinkURL = inboxMessage.deepLinkURL, !deepLinkURL.isEmpty {
            var deepLinkAction = [String: Any]()
            
            deepLinkAction[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.General.navigation
            deepLinkAction[MoEngagePluginConstants.General.navigationType] = MoEngagePluginConstants.Inbox.deepLink
            deepLinkAction[MoEngagePluginConstants.General.value] = deepLinkURL
            deepLinkAction[MoEngagePluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(deepLinkAction)
        }
        
        if let richLandingURL = inboxMessage.richLandingURL, !richLandingURL.isEmpty {
            var richLandingAction = [String: Any]()
            
            richLandingAction[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.General.navigation
            richLandingAction[MoEngagePluginConstants.General.navigationType] = MoEngagePluginConstants.Inbox.richLanding
            richLandingAction[MoEngagePluginConstants.General.value] = richLandingURL
            richLandingAction[MoEngagePluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(richLandingAction)
        }
        
        if let screenName = inboxMessage.screenName, !screenName.isEmpty {
            var navigateToScreenAction = [String: Any]()
            
            navigateToScreenAction[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.General.navigation
            navigateToScreenAction[MoEngagePluginConstants.General.navigationType] = MoEngagePluginConstants.Inbox.screenName
            navigateToScreenAction[MoEngagePluginConstants.General.value] = screenName
            navigateToScreenAction[MoEngagePluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(navigateToScreenAction)
        }
        
        return actionDict
    }
    
    static func getUnreadCountPayload(count: Int, identifier: String) -> [String: Any] {
        let accountMeta = fetchAccountPayload(identifier: identifier)
        let data = [MoEngagePluginConstants.Inbox.unClickedCount: count]
        return [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: data]
    }
    
    static func getCampaignIdForStats(inboxDict: [String: Any]) -> String? {
        if let data = inboxDict[MoEngagePluginConstants.General.data] as? [String: Any],
           let campaignID = data[MoEngagePluginConstants.General.campaignId] as? String,
           !campaignID.isEmpty {
            return campaignID
        }
        
        return nil
    }
}
