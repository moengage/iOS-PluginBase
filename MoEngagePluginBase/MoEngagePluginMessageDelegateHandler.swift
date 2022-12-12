//
//  MoEngagePluginMessageDelegateHandler.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 09/08/22.
//

import Foundation
import MoEngageSDK

final class MoEngagePluginMessageDelegateHandler: NSObject, MOMessagingDelegate {
    
    private var identifier: String
    
    private var messageHandler: MoEngagePluginMessageHandler? {
        return MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
    }
    
    init(identifier: String) {
        self.identifier = identifier
        super.init()
        setMessagingDelegate()
    }
    
    private func setMessagingDelegate() {
        MOMessaging.sharedInstance.setMessagingDelegate(self, forAppID: identifier)
        
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    
                    guard let sharedApplication = MOCoreUtils.sharedUIApplication(),
                          sharedApplication.isRegisteredForRemoteNotifications
                    else {
                        return
                    }
                    
                    if let currentDelegate = UNUserNotificationCenter.current().delegate {
                        MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: currentDelegate)
                    } else {
                        MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: self)
                    }
                }
            default:
                break
            }
        })
    }
    
    func notificationRegistered(withDeviceToken deviceToken: String) {
        let message = MoEngagePluginUtils.createTokenPayload(deviceToken: deviceToken)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.pushTokenGenerated, message: message)
    }
    
    func notificationClicked(withScreenName screenName: String?, kvPairs: [AnyHashable: Any]?, andPushPayload userInfo: [AnyHashable: Any]) {
        let message = MoEngagePluginUtils.createPushClickPayload(withScreenName: screenName, kvPairs: kvPairs, andPushPayload: userInfo, identifier: identifier)
        messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.pushClicked, message: message)
    }
    
}

extension MoEngagePluginMessageDelegateHandler: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response)
        completionHandler()
    }
}
