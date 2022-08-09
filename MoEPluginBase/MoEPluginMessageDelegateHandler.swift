//
//  MoEPluginMessageDelegateHandler.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 09/08/22.
//

import Foundation
import MoEngageSDK

extension MoEPluginController: MOMessagingDelegate {
    
    func notificationRegistered(withDeviceToken deviceToken: String) {
        let message = MoEPluginController.fetchTokenPayload(deviceToken: deviceToken)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.pushTokenGenerated, message: message)
    }
    
    func notificationClicked(withScreenName screenName: String?, kvPairs: [AnyHashable: Any]?, andPushPayload userInfo: [AnyHashable: Any]) {
        let message = MoEPluginController.fetchPushClickedPayload(withScreenName: screenName, kvPairs: kvPairs, andPushPayload: userInfo, identifier: identifier)
        messageHandler.flushMessage(eventName: MoEPluginConstants.CallBackEvents.pushClicked, message: message)
    }
}

extension MoEPluginController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response)
        completionHandler()
    }
}
