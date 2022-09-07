//
//  MoEngagePluginMessageInstanceProvider.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 10/08/22.
//

import Foundation

final class MoEngagePluginMessageInstanceProvider {
    
    private var messageHandlers = [String: Any]()
    static let sharedInstance = MoEngagePluginMessageInstanceProvider()
    
    private init() {
    }
    
    func getMessageQueueHandler(identifier: String) -> MoEngagePluginMessageHandler? {
        if identifier.isEmpty {
            return nil
        }
        
        if let messageHandler = messageHandlers[identifier] as? MoEngagePluginMessageHandler {
            return messageHandler
        } else {
            let messageHandler  = MoEngagePluginMessageHandler(identifier: identifier)
            messageHandlers[identifier] = messageHandler
            return messageHandler
        }
    }
}
