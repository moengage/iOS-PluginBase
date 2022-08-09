//
//  MoEPluginInAppDelegateHandler.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 09/08/22.
//

import Foundation
import MoEngageInApps

extension MoEPluginController: MOInAppNativDelegate {
    func inAppShown(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEPluginController.fetchInAppPayload(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppShown, message: message)
    }
    
    func inAppDismissed(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEPluginController.fetchInAppPayload(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppDismissed, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andCustomActionInfo customAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEPluginController.fetchInAppPayload(inAppCampaign: inappCampaign, inAppAction: customAction, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppCustomAction, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andNavigationActionInfo navigationAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEPluginController.fetchInAppPayload(inAppCampaign: inappCampaign, inAppAction: navigationAction, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppClicked, message: message)
    }
}
