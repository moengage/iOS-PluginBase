//
//  MoEngagePluginInboxBridge.swift
//  MoEngagePluginInbox
//
//  Created by Rakshitha on 27/06/22.
//

import Foundation
import MoEngageInbox
import MoEngagePluginBase

@objc final public class MoEngagePluginInboxBridge: NSObject {
    @objc public static let sharedInstance = MoEngagePluginInboxBridge()
    
    private override init() {
    }
    
    @objc public func getInboxMessages(_ inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        guard let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inboxDict) else { return }
        MoEngageSDKInbox.sharedInstance.getInboxMessages(forAppID: identifier) { [weak self] inboxMessages, _ in
            let payload = MoEngagePluginInboxUtils.inboxEntryToJSON(inboxMessages: inboxMessages, identifier: identifier)
            completionHandler(payload)
        }
        
    }
    
    @objc public func trackInboxClick(_ inboxDict: [String: Any]) {
        guard let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inboxDict),
              let campaignID = MoEngagePluginInboxUtils.fetchCampaignIdFromPayload(inboxDict: inboxDict)
        else { return }
        
        MoEngageSDKInbox.sharedInstance.trackInboxClick(withCampaignID: campaignID, forAppID: identifier)
    }
    
    @objc public func deleteInboxEntry(_ inboxDict: [String: Any]) {
        guard let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inboxDict),
              let campaignID = MoEngagePluginInboxUtils.fetchCampaignIdFromPayload(inboxDict: inboxDict)
        else { return }
        
        MoEngageSDKInbox.sharedInstance.removeInboxMessage(withCampaignID: campaignID, forAppID: identifier)
    }
    
    @objc public func getUnreadMessageCount(_ inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        
        guard let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inboxDict) else { return }
        
        MoEngageSDKInbox.sharedInstance.getUnreadNotificationCount(forAppID: identifier) { [weak self] count, _ in
            let payload = MoEngagePluginInboxUtils.createUnreadCountPayload(count: count, identifier: identifier)
            completionHandler(payload)
        }
    }
}
