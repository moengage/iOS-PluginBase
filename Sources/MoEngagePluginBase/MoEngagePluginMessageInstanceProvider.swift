//
//  MoEngagePluginMessageInstanceProvider.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 10/08/22.
//

import Foundation

final class MoEngagePluginMessageInstanceProvider {
    
    private var messageHandlers = [String: MoEngagePluginMessageHandler]()
    static let sharedInstance = MoEngagePluginMessageInstanceProvider()
    
    private var syncQueue = DispatchQueue(label: "com.moengage.pluginBase.instanceProvider")
    
    private init() {
    }
    
    func getMessageQueueHandler(identifier: String) -> MoEngagePluginMessageHandler? {
        syncQueue.sync {
            if let messageHandler = messageHandlers[identifier] {
                return messageHandler
            } else {
                let messageHandler  = MoEngagePluginMessageHandler(identifier: identifier)
                messageHandlers[identifier] = messageHandler
                return messageHandler
            }
        }
    }
}
