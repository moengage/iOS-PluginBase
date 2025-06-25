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

class  MoEngagePluginInboxUtils {
    
    static func inboxEntryToJSON(inboxMessages: [MoEngageInboxEntry], identifier: String) -> [String: Any] {
        let accountMeta = MoEngagePluginUtils.createAccountPayload(identifier: identifier)
        var messages = [[String: Any]]()
        
        for inboxMessage in inboxMessages {
            var message = [String: Any]()
            
            message[MoEngagePluginConstants.General.campaignId] = inboxMessage.campaignID
            message[MoEngagePluginInboxConstants.Inbox.text] = createTextPayload(inboxMessage: inboxMessage)
            message[MoEngagePluginInboxConstants.Inbox.isClicked] = inboxMessage.isRead
            message[MoEngagePluginInboxConstants.Inbox.receivedTime] = MoEngageDateUtils.getString(forDate: inboxMessage.receivedDate, withFormat: MoEngageCoreConstants.DateTimeFormats.iso8601, andForGMTTimeZone: true)
            message[MoEngagePluginInboxConstants.Inbox.expiry] = MoEngageDateUtils.getString(forDate: inboxMessage.inboxExpiryDate, withFormat:MoEngageCoreConstants.DateTimeFormats.iso8601, andForGMTTimeZone: true)
            message[MoEngagePluginConstants.General.payload] = inboxMessage.notificationPayloadDict
            message[MoEngagePluginInboxConstants.Inbox.action] = MoEngagePluginInboxUtils.createActionPayload(inboxMessage: inboxMessage)
            
            if let mediaPayload = createMediaPayload(inboxMessage: inboxMessage) {
                message[MoEngagePluginInboxConstants.Inbox.media] = mediaPayload
            }
            message[MoEngagePluginInboxConstants.Inbox.groupKey] = inboxMessage.groupKey
            message[MoEngagePluginInboxConstants.Inbox.notificationId] = inboxMessage.collapseId
            message[MoEngagePluginInboxConstants.Inbox.sentTime] = MoEngageDateUtils.getString(forDate: inboxMessage.sentTime, withFormat:MoEngageCoreConstants.DateTimeFormats.iso8601, andForGMTTimeZone: true)
            messages.append(message)
        }
        
        let data = [MoEngagePluginConstants.General.platform: MoEngagePluginConstants.General.iOS, MoEngagePluginInboxConstants.Inbox.messages: messages] as [String: Any]
        return [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: data]
    }
    
    static func createTextPayload(inboxMessage: MoEngageInboxEntry) -> [String: Any] {
        var textPayload = [String: Any]()
        
        textPayload[MoEngagePluginInboxConstants.Inbox.title] = inboxMessage.notificationTitle
        textPayload[MoEngagePluginInboxConstants.Inbox.subtitle] = inboxMessage.notificationSubTitle
        textPayload[MoEngagePluginInboxConstants.Inbox.message] = inboxMessage.notificationBody
        
        return textPayload
    }
    
    static func createMediaPayload(inboxMessage: MoEngageInboxEntry) -> [String: Any]? {        
        if let url = inboxMessage.notificationMediaURL,
           let type = inboxMessage.moengageDict[ MoEngagePluginInboxConstants.Inbox.mediaType]  {
            var mediaPayload = [String: Any]()
            mediaPayload[MoEngagePluginInboxConstants.Inbox.type] = type
            mediaPayload[MoEngagePluginInboxConstants.Inbox.url] = url
            mediaPayload[MoEngagePluginInboxConstants.Inbox.accessibility] = createAccessibilityPayload(for: inboxMessage)
            return mediaPayload
        }
        
        return nil
    }
    
    static func createAccessibilityPayload(for inboxMessage: MoEngageInboxEntry) -> [String: Any]? {
        var payload = [String: Any]()
        if let accessibilityData = inboxMessage.accessibilityData {
            payload[MoEngagePluginInboxConstants.Inbox.accessibilityText] = accessibilityData.label
            payload[MoEngagePluginInboxConstants.Inbox.accessibilityHint] = accessibilityData.hint
        }
        return payload
    }
    
    static func createActionPayload(inboxMessage: MoEngageInboxEntry) -> [[String: Any]] {
        var actionDict = [[String: Any]]()
        
        if let deepLinkURL = inboxMessage.deepLinkURL, !deepLinkURL.isEmpty {
            var deepLinkAction = [String: Any]()
            
            deepLinkAction[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.General.navigation
            deepLinkAction[MoEngagePluginConstants.General.navigationType] = MoEngagePluginInboxConstants.Inbox.deepLink
            deepLinkAction[MoEngagePluginConstants.General.value] = deepLinkURL
            deepLinkAction[MoEngagePluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(deepLinkAction)
        }
        
        if let richLandingURL = inboxMessage.richLandingURL, !richLandingURL.isEmpty {
            var richLandingAction = [String: Any]()
            
            richLandingAction[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.General.navigation
            richLandingAction[MoEngagePluginConstants.General.navigationType] = MoEngagePluginInboxConstants.Inbox.richLanding
            richLandingAction[MoEngagePluginConstants.General.value] = richLandingURL
            richLandingAction[MoEngagePluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(richLandingAction)
        }
        
        if let screenName = inboxMessage.screenName, !screenName.isEmpty {
            var navigateToScreenAction = [String: Any]()
            
            navigateToScreenAction[MoEngagePluginConstants.General.actionType] = MoEngagePluginConstants.General.navigation
            navigateToScreenAction[MoEngagePluginConstants.General.navigationType] = MoEngagePluginInboxConstants.Inbox.screenName
            navigateToScreenAction[MoEngagePluginConstants.General.value] = screenName
            navigateToScreenAction[MoEngagePluginConstants.General.kvPair] = inboxMessage.screenDataDict
            
            actionDict.append(navigateToScreenAction)
        }
        
        return actionDict
    }
    
    static func createUnreadCountPayload(count: Int, identifier: String) -> [String: Any] {
        let accountMeta = MoEngagePluginUtils.createAccountPayload(identifier: identifier)
        let data = [MoEngagePluginInboxConstants.Inbox.unClickedCount: count]
        return [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: data]
    }
    
    static func fetchCampaignIdFromPayload(inboxDict: [String: Any]) -> String? {
        if let data = inboxDict[MoEngagePluginConstants.General.data] as? [String: Any],
           let campaignID = data[MoEngagePluginConstants.General.campaignId] as? String,
           !campaignID.isEmpty {
            return campaignID
        }
        
        return nil
    }
}
