//
//  MoEMessageUtils.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 11/08/22.
//

import Foundation

@objc public protocol MoEPluginBridgeDelegate {
    @objc func sendMessage(event: String, message: [String: Any])
}

protocol MoEMessageHandler {
    static func fetchMessageQueueHandler(identifier: String) -> MoEMessageQueueHandler?
}

extension MoEMessageHandler {
    static func fetchMessageQueueHandler(identifier: String) -> MoEMessageQueueHandler? {
        return MoEMessageInstanceProvider.sharedInstance.getMessageQueueHandler(identifier: identifier)
    }
}
