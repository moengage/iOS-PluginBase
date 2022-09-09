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
    func inboxEntryToJSON(inboxMessages: [MOInboxEntry], identifier: String) -> [String: Any]
    func createUnreadCountPayload(count: Int, identifier: String) -> [String: Any]
    func fetchCampaignIdFromPayload(inboxDict: [String: Any]) -> String?
}

extension MoEngagePluginInboxUtils {
    
    func inboxEntryToJSON(inboxMessages: [MOInboxEntry], identifier: String) -> [String: Any] {
        let accountMeta = createAccountPayload(identifier: identifier)
        var messages = [[String: Any]]()
        
        for inboxMessage in inboxMessages {
            var message = [String: Any]()
            
            message[MoEngagePluginConstants.General.campaignId] = inboxMessage.campaignID
            message[MoEngagePluginInboxConstants.Inbox.text] = createTextPayload(inboxMessage: inboxMessage)
            message[MoEngagePluginInboxConstants.Inbox.media] = createMediaPayload(inboxMessage: inboxMessage)
            message[MoEngagePluginInboxConstants.Inbox.isClicked] = inboxMessage.isRead
            message[MoEngagePluginInboxConstants.Inbox.receivedTime] = MODateUtils.getString(forDate: inboxMessage.receivedDate, withFormat:MOCoreConstants.DateTimeFormats.iso8601, andForGMTTimeZone: true)
            message[MoEngagePluginInboxConstants.Inbox.expiry] = MODateUtils.getString(forDate: inboxMessage.inboxExpiryDate, withFormat:MOCoreConstants.DateTimeFormats.iso8601, andForGMTTimeZone: true)
            message[MoEngagePluginConstants.General.payload] = inboxMessage.notificationPayloadDict
            message[MoEngagePluginInboxConstants.Inbox.action] = createActionPayload(inboxMessage: inboxMessage)
            
            messages.append(message)
        }
        
        let data = [MoEngagePluginConstants.General.platform: MoEngagePluginConstants.General.iOS, MoEngagePluginInboxConstants.Inbox.messages: messages] as [String: Any]
        return [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: data]
    }
    
     func createTextPayload(inboxMessage: MOInboxEntry) -> [String: Any] {
        var textPayload = [String: Any]()
        
        textPayload[MoEngagePluginInboxConstants.Inbox.title] = inboxMessage.notificationTitle
        textPayload[MoEngagePluginInboxConstants.Inbox.subtitle] = inboxMessage.notificationSubTitle
        textPayload[MoEngagePluginInboxConstants.Inbox.message] = inboxMessage.notificationBody
        
        return textPayload
    }
    
    func createMediaPayload(inboxMessage: MOInboxEntry) -> [String: Any] {
        var mediaPayload = [String: Any]()
        
        let moengageDict = inboxMessage.notificationPayloadDict[MoEngagePluginInboxConstants.Inbox.moengage] as? [String: Any]
        mediaPayload[MoEngagePluginInboxConstants.Inbox.type] = moengageDict?[MoEngagePluginInboxConstants.Inbox.mediaType]
        mediaPayload[MoEngagePluginInboxConstants.Inbox.url] = inboxMessage.notificationMediaURL
        
        return mediaPayload
    }
    
    func createActionPayload(inboxMessage: MOInboxEntry) -> [[String: Any]] {
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
    
    func createUnreadCountPayload(count: Int, identifier: String) -> [String: Any] {
        let accountMeta = createAccountPayload(identifier: identifier)
        let data = [MoEngagePluginInboxConstants.Inbox.unClickedCount: count]
        return [MoEngagePluginConstants.General.accountMeta: accountMeta, MoEngagePluginConstants.General.data: data]
    }
    
    func fetchCampaignIdFromPayload(inboxDict: [String: Any]) -> String? {
        if let data = inboxDict[MoEngagePluginConstants.General.data] as? [String: Any],
           let campaignID = data[MoEngagePluginConstants.General.campaignId] as? String,
           !campaignID.isEmpty {
            return campaignID
        }
        
        return nil
    }
}
