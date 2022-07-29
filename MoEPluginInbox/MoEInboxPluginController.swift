//
//  MoEInboxPluginController.swift
//  MoEPluginInbox
//
//  Created by Rakshitha on 27/06/22.
//

import Foundation
import MoEngageInbox

final class MoEInboxPluginController: MoEInboxUtils {
    private var identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    func getInboxMessages(inboxDict: [String: Any], completionHandler:@escaping(([String: Any]) -> Void)) {
        MOInbox.sharedInstance.getInboxMessages(forAppID: identifier) { [weak self] inboxMessages, _ in
            
            guard let self = self else { return }
            
            let payload = MoEInboxPluginController.getInboxPayload(inboxMessages: inboxMessages, identifier: self.identifier)
            completionHandler(payload)
        }
    }
    
    func trackInboxClick(inboxDict: [String: Any]) {
        if let campaignID = MoEInboxPluginController.getCampaignIdForStats(inboxDict: inboxDict) {
            MOInbox.sharedInstance.trackInboxClick(withCampaignID: campaignID, forAppID: identifier)
        }
    }
    
    func deleteInboxEntry(inboxDict: [String: Any]) {
        if let campaignID = MoEInboxPluginController.getCampaignIdForStats(inboxDict: inboxDict) {
            MOInbox.sharedInstance.removeInboxMessage(withCampaignID: campaignID, forAppID: identifier)
        }
    }
    
    func getUnreadMessageCount(inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        MOInbox.sharedInstance.getUnreadNotificationCount(forAppID: identifier) { [weak self] count, _ in
            
            guard let self = self else { return }
            
            let payload = MoEInboxPluginController.getUnreadCountPayload(count: count, identifier: self.identifier)
            completionHandler(payload)
        }
    }
    
}
