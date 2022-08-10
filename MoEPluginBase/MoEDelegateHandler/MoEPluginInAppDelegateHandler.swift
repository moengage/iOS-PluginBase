//
//  MoEPluginInAppDelegateHandler.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 10/08/22.
//

import Foundation
import MoEngageInApps

class MoEPluginInAppDelegateHandler: NSObject, MOInAppNativDelegate, MoEPluginUtils, MoEMessageHandler {
    
    var identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
    }

    var messageHandler: MoEMessageQueueHandler? {
        return MoEPluginInAppDelegateHandler.fetchMessageQueueHandler(identifier: identifier)
    }
    
    func inAppShown(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEPluginInAppDelegateHandler.fetchInAppPayload(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppShown, message: message)
    }
    
    func inAppDismissed(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEPluginInAppDelegateHandler.fetchInAppPayload(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppDismissed, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andCustomActionInfo customAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEPluginInAppDelegateHandler.fetchInAppPayload(inAppCampaign: inappCampaign, inAppAction: customAction, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppCustomAction, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andNavigationActionInfo navigationAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEPluginInAppDelegateHandler.fetchInAppPayload(inAppCampaign: inappCampaign, inAppAction: navigationAction, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppClicked, message: message)
    }
    
}
