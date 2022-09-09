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
        guard let identifier = fetchIdentifierFromPayload(attribute: inboxDict) else { return }
        MOInbox.sharedInstance.getInboxMessages(forAppID: identifier) { [weak self] inboxMessages, _ in
            guard let self = self
            else
            {
                completionHandler([:])
                return
            }
            
            let payload = self.inboxEntryToJSON(inboxMessages: inboxMessages, identifier: identifier)
            completionHandler(payload)
        }
        
    }
    
    @objc public func trackInboxClick(_ inboxDict: [String: Any]) {
        guard let identifier = fetchIdentifierFromPayload(attribute: inboxDict),
              let campaignID = fetchCampaignIdFromPayload(inboxDict: inboxDict)
        else { return }
        
        MOInbox.sharedInstance.trackInboxClick(withCampaignID: campaignID, forAppID: identifier)
    }
    
    @objc public func deleteInboxEntry(_ inboxDict: [String: Any]) {
        guard let identifier = fetchIdentifierFromPayload(attribute: inboxDict),
              let campaignID = fetchCampaignIdFromPayload(inboxDict: inboxDict)
        else { return }
        
        MOInbox.sharedInstance.removeInboxMessage(withCampaignID: campaignID, forAppID: identifier)
    }
    
    @objc public func getUnreadMessageCount(_ inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        
        guard let identifier = fetchIdentifierFromPayload(attribute: inboxDict) else { return }
        
        MOInbox.sharedInstance.getUnreadNotificationCount(forAppID: identifier) { [weak self] count, _ in
            guard let self = self
            else
            {
                completionHandler([:])
                return
            }
            
            let payload = self.createUnreadCountPayload(count: count, identifier: identifier)
            completionHandler(payload)
        }
    }
}
