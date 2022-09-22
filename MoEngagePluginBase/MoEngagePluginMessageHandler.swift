//
//  MoEngageMessageHandler.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 24/06/22.
//

import Foundation
import MoEngageSDK

final class MoEngagePluginMessageHandler {
    private var identifier: String
    private var messageQueue = [[String: Any]]()
    private var isSDKInitialized = false
    private weak var delegate: MoEngagePluginBridgeDelegate?
    
    private let syncMessageQueue = DispatchQueue(label: "com.moengage.pluginBase.messageQueue")
    
    init(identifier: String) {
        self.identifier =  identifier
    }
    
    func setBridgeDelegate(delegate: MoEngagePluginBridgeDelegate) {
        self.delegate = delegate
    }
    
    func flushMessage(eventName: String, message: [String: Any]? = nil) {
        guard let message = message, !message.isEmpty else {
            return
        }

        if isSDKInitialized {
            delegate?.sendMessage(event: eventName, message: message)
        } else {
            syncMessageQueue.sync {
                let payload = [MoEngagePluginConstants.General.event: eventName, MoEngagePluginConstants.General.message: message] as [String: Any]
                messageQueue.append(payload)
            }
        }
    }
    
    func flushAllMessages() {
        isSDKInitialized = true
        syncMessageQueue.sync {
            for payload in messageQueue {
                if let event = payload[MoEngagePluginConstants.General.event] as? String,
                   let message = payload[MoEngagePluginConstants.General.message] as? [String: Any] {
                    flushMessage(eventName: event, message: message)
                }
            }
            messageQueue.removeAll()
        }
    }
}
