//
//  MoEMessageInstanceProvider.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 10/08/22.
//

import Foundation

final class MoEMessageInstanceProvider {
    
    private var messageHandlers = [String: Any]()
    static let sharedInstance = MoEMessageInstanceProvider()
    
    private init() {
    }
    
    func getMessageQueueHandler(identifier: String) -> MoEMessageQueueHandler? {
        if identifier.isEmpty {
            return nil
        }
        
        if let messageHandler = messageHandlers[identifier] as? MoEMessageQueueHandler {
            return messageHandler
        } else {
            let messageHandler  = MoEMessageQueueHandler(identifier: identifier)
            messageHandlers[identifier] = messageHandler
            return messageHandler
        }
    }
}
