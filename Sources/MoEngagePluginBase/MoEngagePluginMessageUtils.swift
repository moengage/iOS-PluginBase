//
//  MoEngagePluginMessageUtils.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 11/08/22.
//

import Foundation

@objc public protocol MoEngagePluginBridgeDelegate {
    @objc func sendMessage(event: String, message: [String: Any])
}

class MoEngagePluginMessageDelegate {
    static func fetchMessageQueueHandler(identifier: String) -> MoEngagePluginMessageHandler? {
        return MoEngagePluginMessageInstanceProvider.sharedInstance.getMessageQueueHandler(identifier: identifier)
    }
}
