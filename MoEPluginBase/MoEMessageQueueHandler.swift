//
//  MoEMessageQueueHandler.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 24/06/22.
//

import Foundation
import MoEngageSDK

@objc public protocol MoEPluginBridgeDelegate {
    @objc func sendMessage(event: String, message: [String: Any])
}

class MoEMessageQueueHandler {
    var identifier: String
    var messageQueue = [[String: Any]]()
    var isSDKInitialized = false
    weak var delegate: MoEPluginBridgeDelegate?
    
    init(identifier: String) {
        self.identifier =  identifier
    }
    
    func setBridgeDelegate(delegate: MoEPluginBridgeDelegate) {
        self.delegate = delegate
    }
    
    func flushMessage(eventName: String, message: [String: Any]) {
        if message.isEmpty {
            return
        }
        
        if isSDKInitialized {
            delegate?.sendMessage(event: eventName, message: message)
        } else {
            let payload = [MoEPluginConstants.General.event: eventName, MoEPluginConstants.General.message: message] as [String : Any]
            messageQueue.append(payload)
        }
    }
    
    func flushAllMessages() {
        isSDKInitialized = true
        
        for messageQueue in messageQueue {
            if let event = messageQueue[MoEPluginConstants.General.event] as? String,
               let message = messageQueue[MoEPluginConstants.General.message] as? [String: Any] {
                flushMessage(eventName: event, message: message)
            }
        }
        
        messageQueue.removeAll()
    }
}
