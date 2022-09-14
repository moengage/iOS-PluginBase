//
//  MoEngagePluginInAppDelegateHandler.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 10/08/22.
//

import Foundation
import MoEngageInApps

final class MoEngagePluginInAppDelegateHandler: NSObject, MOInAppNativDelegate {
    
    private static var handlers = [String: Any]()

    private var identifier: String
    
    private var messageHandler: MoEngagePluginMessageHandler? {
        return MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
    }
    
    init(identifier: String) {
        self.identifier = identifier
        super.init()
        
        setInAppDelegate()
    }
    
    private func setInAppDelegate() {
        MOInApp.sharedInstance().setInAppDelegate(self, forAppID: identifier)
        MoEngagePluginInAppDelegateHandler.handlers[identifier] = self
    }

    func inAppShown(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppShown, message: message)
    }
    
    func inAppDismissed(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppDismissed, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andCustomActionInfo customAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, inAppAction: customAction, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppCustomAction, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andNavigationActionInfo navigationAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, inAppAction: navigationAction, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppClicked, message: message)
    }
    
}
