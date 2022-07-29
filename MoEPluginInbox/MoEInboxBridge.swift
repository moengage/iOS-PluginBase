//
//  MoEInboxBridge.swift
//  MoEPluginInbox
//
//  Created by Rakshitha on 27/06/22.
//

import Foundation
import MoEngageInbox
import MoEPluginBase

@objc final public class MoEInboxBridge: NSObject, MoEPluginUtils {
    @objc public static let sharedInstance = MoEInboxBridge()
    
    private override init() {
    }
    
    @objc public func getInboxMessages(_ inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        if let controller = getController(inboxDict: inboxDict) {
            controller.getInboxMessages(inboxDict: inboxDict, completionHandler: completionHandler)
        }
    }
    
    @objc public func trackInboxClick(_ inboxDict: [String: Any]) {
        if let controller = getController(inboxDict: inboxDict) {
            controller.trackInboxClick(inboxDict: inboxDict)
        }
    }
    
    @objc public func deleteInboxEntry(_ inboxDict: [String: Any]) {
        if let controller = getController(inboxDict: inboxDict) {
            controller.deleteInboxEntry(inboxDict: inboxDict)
        }
    }
    
    @objc public func getUnreadMessageCount(_ inboxDict: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        if let controller = getController(inboxDict: inboxDict) {
            controller.getUnreadMessageCount(inboxDict: inboxDict, completionHandler: completionHandler)
        }
    }
        
    private func getController(inboxDict: [String: Any]) -> MoEInboxPluginController? {
        if let appID = MoEInboxBridge.fetchIdentifier(attribute: inboxDict),
           let controller = MoEInboxPluginCoordinator.sharedInstance.getPluginCoordinator(identifier: appID) {
            return controller
            
        }
        return nil
    }
}
