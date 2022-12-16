//
//  MoEngagePluginInAppDelegateHandler.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 10/08/22.
//

import Foundation
import MoEngageInApps

final class MoEngagePluginInAppDelegateHandler: NSObject, MoEngageInAppNativeDelegate {
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
        MoEngageSDKInApp.sharedInstance.setInAppDelegate(self, forAppId: identifier)
        MoEngagePluginInAppDelegateHandler.handlers[identifier] = self
    }
    
    func inAppShown(withCampaignInfo inappCampaign: MoEngageInAppCampaign, forAccountMeta accountMeta: MoEngageAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppShown, message: message)
    }
    
    func inAppDismissed(withCampaignInfo inappCampaign: MoEngageInAppCampaign, forAccountMeta accountMeta: MoEngageAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppDismissed, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MoEngageInAppCampaign, andNavigationActionInfo navigationAction: MoEngageInAppAction, forAccountMeta accountMeta: MoEngageAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, inAppAction: navigationAction, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppClicked, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MoEngageInAppCampaign, andCustomActionInfo customAction: MoEngageInAppAction, forAccountMeta accountMeta: MoEngageAccountMeta) {
        let message = MoEngagePluginUtils.inAppCampaignToJSON(inAppCampaign: inappCampaign, inAppAction: customAction, identifier: accountMeta.appID)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppCustomAction, message: message)
    }
    
    func selfHandledInAppTriggered(withInfo inappCampaign: MoEngageInApps.MoEngageInAppSelfHandledCampaign, forAccountMeta accountMeta: MoEngageCore.MoEngageAccountMeta) {
    }
    
}
