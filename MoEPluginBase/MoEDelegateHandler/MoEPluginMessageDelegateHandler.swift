//
//  MoEPluginMessageDelegateHandler.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 09/08/22.
//

import Foundation
import MoEngageSDK

class MoEPluginMessageDelegateHandler: NSObject, MOMessagingDelegate, MoEPluginUtils, MoEMessageHandler {
    
    var identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    var messageHandler: MoEMessageQueueHandler? {
        return MoEPluginMessageDelegateHandler.fetchMessageQueueHandler(identifier: identifier)
    }
    
    func notificationRegistered(withDeviceToken deviceToken: String) {
        let message = MoEPluginMessageDelegateHandler.fetchTokenPayload(deviceToken: deviceToken)
        messageHandler?.flushMessage(eventName: MoEPluginConstants.CallBackEvents.pushTokenGenerated, message: message)
    }
    
    func notificationClicked(withScreenName screenName: String?, kvPairs: [AnyHashable: Any]?, andPushPayload userInfo: [AnyHashable: Any]) {
        let message = MoEPluginMessageDelegateHandler.fetchPushClickedPayload(withScreenName: screenName, kvPairs: kvPairs, andPushPayload: userInfo, identifier: "")
        messageHandler?.flushMessage(eventName: MoEPluginConstants.CallBackEvents.pushClicked, message: message)
    }
    
}

extension MoEPluginMessageDelegateHandler: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngage.sharedInstance().userNotificationCenter(center, didReceive: response)
        completionHandler()
    }
}
