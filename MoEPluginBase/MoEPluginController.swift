//
//  MoEPluginController.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps
import UserNotifications
import CoreText

class MoEPluginController: NSObject {
    var identifier: String
    var messageHandler: MoEMessageQueueHandler
    
    init(identifier: String){
        self.identifier = identifier
        messageHandler = MoEMessageQueueHandler(identifier: identifier)
    }
    
    func pluginInitialized(accountInfo: [String: Any]) {
        messageHandler.flushAllMessages()
    }
    
    func setBridgeDelegate(delegate: MoEPluginBridgeDelegate) {
        messageHandler.setBridgeDelegate(delegate: delegate)
    }
    
    func initializeDefaultInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions:[String: Any]) {
        #if DEBUG
        MoEngage.sharedInstance().initializeDefaultTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
        MoEngage.sharedInstance().initializeDefaultLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        handleSDKState(sdkState)

        setDelegates()
    }
    
    func initializeInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions:[String: Any]) {
        #if DEBUG
        MoEngage.sharedInstance().initializeTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
        MoEngage.sharedInstance().initializeLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        handleSDKState(sdkState)

        setDelegates()
    }
    
    private func setDelegates() {
        setMoEngageDelegates()
        setNotificationDelegate()
    }
    
    private func setMoEngageDelegates() {
        MOMessaging.sharedInstance.setMessagingDelegate(self, forAppID: identifier)
        MOInApp.sharedInstance().setInAppDelegate(self, forAppID: identifier)
    }
    
    private func setNotificationDelegate() {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            if UNUserNotificationCenter.current().delegate == nil {
                MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: self)
            } else {
                MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: UNUserNotificationCenter.current().delegate)
            }
        }
    }
    
    //MARK: Opt out
    fileprivate func handleSDKState(_ sdkState: Bool) {
        if sdkState {
            MoEngage.sharedInstance().enableSDK(forAppID: identifier)
        } else {
            MoEngage.sharedInstance().disableSDK(forAppID: identifier)
        }
    }
    
    func updateSDKState(sdkState: [String: Any]) {
        guard let dataDict = sdkState[MoEPluginConstants.General.data] as? [String: Any],
              let sdkState = dataDict[MoEPluginConstants.SDKState.isSdkEnabled] as? Bool
        else
        {
            return
        }
        
        handleSDKState(sdkState)
    }
    
    func optOutDataTracking(dataTrack: [String: Any]) {
        guard let dataDict = dataTrack[MoEPluginConstants.General.data] as? [String: Any],
              let type = dataDict[MoEPluginConstants.General.type] as? String,
              let state = dataDict[MoEPluginConstants.SDKState.state] as? Bool
                
        else
        {
            return
        }
        
        if type == MoEPluginConstants.SDKState.data {
            if state {
                MOAnalytics.sharedInstance.enableDataTracking(forAppID: identifier)
            } else {
                MOAnalytics.sharedInstance.disableDataTracking(forAppID: identifier)
            }
        }
    }
    
    //MARK: Analytics
    
    func setAppStatus(appStatus:[String: Any]) {
        if let dataDict = appStatus[MoEPluginConstants.General.data] as? [String: Any],
           let appStatus = dataDict[MoEPluginConstants.AppStatus.appStatus] as? String,
           !appStatus.isEmpty {
            
            switch appStatus {
            case MoEPluginConstants.AppStatus.install:
                MoEngage.sharedInstance().appStatus(.install, forAppID: identifier)
            case MoEPluginConstants.AppStatus.update:
                MoEngage.sharedInstance().appStatus(.update, forAppID: identifier)
            default:
                break
            }
        }
    }
    
    func setAlias(alias: [String: Any]) {
        if let dataDict = alias[MoEPluginConstants.General.data] as? [String: Any],
           let aliasValue = dataDict[MoEPluginConstants.UserAttribute.alias] as? String,
           !aliasValue.isEmpty {
            MOAnalytics.sharedInstance.setAlias(aliasValue, forAppID: identifier)
        }
    }
    
    func resetUser(userAttribute: [String: Any]) {
        MOAnalytics.sharedInstance.resetUser(forAppID: identifier)
    }
    
    func setUserAttribute(userAttribute: [String: Any]) {
        guard let dataDict = userAttribute[MoEPluginConstants.General.data] as? [String: Any],
              let type = dataDict[MoEPluginConstants.General.type] as? String,
              let attributeName = dataDict[MoEPluginConstants.UserAttribute.attributeName] as? String
        else
        {
            return
        }
        
        let attributeValue = dataDict[MoEPluginConstants.UserAttribute.attributeValue]
        
        switch type {
        case MoEPluginConstants.UserAttribute.general:
            MOAnalytics.sharedInstance.setUserAttribute(attributeValue, withAttributeName: attributeName, forAppID: identifier)
            
        case MoEPluginConstants.UserAttribute.timestamp:
            if let timeStamp = attributeValue as? String {
                MOAnalytics.sharedInstance.setUserAttributeISODate(timeStamp, withAttributeName:attributeName,forAppID: identifier)
            }
            
        case MoEPluginConstants.UserAttribute.location:
            if let locationAttributeDict = dataDict[MoEPluginConstants.UserAttribute.locationAttribute] as? [String: Any],
               let latitude = locationAttributeDict[MoEPluginConstants.UserAttribute.latitude] as? Double,
               let longitude = locationAttributeDict[MoEPluginConstants.UserAttribute.longitude] as? Double
            {
                MOAnalytics.sharedInstance.setLocation(MOGeoLocation(withLatitude: latitude, andLongitude: longitude), withAttributeName: attributeName, forAppID: identifier)
            }
            
        default:
            break
        }
    }
    
    func trackEvent(eventAttribute: [String: Any]) {
        guard let dataDict = eventAttribute[MoEPluginConstants.General.data] as? [String: Any],
              let eventName = dataDict[MoEPluginConstants.EventTracking.eventName] as? String
        else
        {
            return
        }
        
        var eventAttributeDict = dataDict[MoEPluginConstants.EventTracking.eventAttributes] as? [String: Any]
        if let isNonInteractive = dataDict[MoEPluginConstants.EventTracking.isNonInteractive] as? Bool {
            eventAttributeDict?[MoEPluginConstants.EventTracking.isNonInteractive] = isNonInteractive
        }
        
        let properties = MOProperties()
        properties.updateAttributes(withPluginPayload: eventAttributeDict)
        MOAnalytics.sharedInstance.trackEvent(eventName, withProperties: properties, forAppID: identifier)
    }
    
    //MARK: InApp
    
    func showInApp(inApp: [String: Any]) {
        MOInApp.sharedInstance().showInAppCampaign(forAppID: identifier)
    }
    
    func getSelfHandledInApp(inApp: [String: Any]) {
        MOInApp.sharedInstance().getSelfHandledInApp(forAppID: identifier) { [weak self] selfHandledCampaign, accountMeta in
            if let self = self {
                let message = MoEPluginUtils.sharedInstance.getSelfHandledPayload(selfHandledCampaign: selfHandledCampaign, identifier: self.identifier)
                self.messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppSelfHandled, message: message)
            }
        }
    }
    
    func setInAppContext(context: [String: Any]) {
        guard let dataDict = context[MoEPluginConstants.General.data] as? [String: Any],
              let contexts = dataDict[MoEPluginConstants.InApp.contexts] as? [String]
        else
        {
            return
        }
        
        MOInApp.sharedInstance().setCurrentInAppContexts(contexts, forAppID: identifier)
    }
    
    func resetInAppContext(context: [String: Any]) {
        MOInApp.sharedInstance().invalidateInAppContexts(forAppID: identifier)
    }
    
    func updateSelfHandledImpression(inApp: [String: Any]) {
        guard let dataDict = inApp[MoEPluginConstants.General.data] as? [String: Any],
              let impressionType = dataDict[MoEPluginConstants.General.type] as? String
        else
        {
            return
        }
        
        let selfHandledCampaign = MOInAppSelfHandledCampaign(campaignPayload: dataDict)
        switch impressionType {
        case MoEPluginConstants.InApp.impression:
            MOInApp.sharedInstance().selfHandledShown(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
        case MoEPluginConstants.InApp.click:
            MOInApp.sharedInstance().selfHandledClicked(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
        case MoEPluginConstants.InApp.dismissed:
            MOInApp.sharedInstance().selfHandledDismissed(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
        default:
            break
        }
    }

}
    
//MARK: MOInAppNativDelegate
extension MoEPluginController: MOInAppNativDelegate {
    func inAppShown(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEPluginUtils.sharedInstance.getInAppPayload(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppShown, message: message)
    }
    
    func inAppDismissed(withCampaignInfo inappCampaign: MOInAppCampaign, for accountMeta: MOAccountMeta) {
        let message = MoEPluginUtils.sharedInstance.getInAppPayload(inAppCampaign: inappCampaign, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppDismissed, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andCustomActionInfo customAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEPluginUtils.sharedInstance.getInAppPayload(inAppCampaign: inappCampaign, inAppAction: customAction, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppCustomAction, message: message)
    }
    
    func inAppClicked(withCampaignInfo inappCampaign: MOInAppCampaign, andNavigationActionInfo navigationAction: MOInAppAction, for accountMeta: MOAccountMeta) {
        let message = MoEPluginUtils.sharedInstance.getInAppPayload(inAppCampaign: inappCampaign, inAppAction: navigationAction, identifier: accountMeta.appID)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.inAppClicked, message: message)
    }
}
    
//MARK: MOMessagingDelegate
extension MoEPluginController: MOMessagingDelegate {
    
    func notificationRegistered(withDeviceToken deviceToken: String) {
        let message = MoEPluginUtils.sharedInstance.getTokenPayload(deviceToken: deviceToken)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.pushTokenGenerated, message: message)
    }
    
    func notificationClicked(withScreenName screenName: String?, kvPairs: [AnyHashable : Any]?, andPushPayload userInfo: [AnyHashable : Any]) {
        let message = MoEPluginUtils.sharedInstance.getPushClickedPayload(withScreenName: screenName, kvPairs: kvPairs, andPushPayload: userInfo, identifier: identifier)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.pushClicked, message: message)
    }
}


//MARK: UNUserNotificationCenterDelegate
extension MoEPluginController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response)
        completionHandler()
    }
}
