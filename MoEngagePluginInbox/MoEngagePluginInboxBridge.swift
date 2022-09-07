//
//  MoEngagePluginInboxBridge.swift
//  MoEngagePluginInbox
//
//  Created by Rakshitha on 27/06/22.
//

import Foundation
import MoEngageInbox
import MoEngagePluginBase

@objc final public class MoEngagePluginInboxBridge: NSObject, MoEngagePluginInboxUtils {
    @objc public static let sharedInstance = MoEngagePluginInboxBridge()
    
    private override init() {
    }
    
    @objc public func getInboxMessages(_ inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        guard let identifier = MoEngagePluginInboxBridge.fetchIdentifier(attribute: inboxDict) else { return }
        MOInbox.sharedInstance.getInboxMessages(forAppID: identifier) { inboxMessages, _ in
            let payload = MoEngagePluginInboxBridge.getInboxPayload(inboxMessages: inboxMessages, identifier: identifier)
            completionHandler(payload)
        }
        
    }
    
    @objc public func trackInboxClick(_ inboxDict: [String: Any]) {
        guard let identifier = MoEngagePluginInboxBridge.fetchIdentifier(attribute: inboxDict),
              let campaignID = MoEngagePluginInboxBridge.getCampaignIdForStats(inboxDict: inboxDict)
        else { return }
        
        MOInbox.sharedInstance.trackInboxClick(withCampaignID: campaignID, forAppID: identifier)
    }
    
    @objc public func deleteInboxEntry(_ inboxDict: [String: Any]) {
        guard let identifier = MoEngagePluginInboxBridge.fetchIdentifier(attribute: inboxDict),
              let campaignID = MoEngagePluginInboxBridge.getCampaignIdForStats(inboxDict: inboxDict)
        else { return }
        
        MOInbox.sharedInstance.removeInboxMessage(withCampaignID: campaignID, forAppID: identifier)
    }
    
    @objc public func getUnreadMessageCount(_ inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        
        guard let identifier = MoEngagePluginInboxBridge.fetchIdentifier(attribute: inboxDict) else { return }
        
        MOInbox.sharedInstance.getUnreadNotificationCount(forAppID: identifier) { count, _ in
            
            let payload = MoEngagePluginInboxBridge.getUnreadCountPayload(count: count, identifier: identifier)
            completionHandler(payload)
        }
    }
}
