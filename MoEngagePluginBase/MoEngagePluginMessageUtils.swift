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

protocol MoEngagePluginMessageDelegate {
    func fetchMessageQueueHandler(identifier: String) -> MoEngagePluginMessageHandler?
}

extension MoEngagePluginMessageDelegate {
    func fetchMessageQueueHandler(identifier: String) -> MoEngagePluginMessageHandler? {
        return MoEngagePluginMessageInstanceProvider.sharedInstance.getMessageQueueHandler(identifier: identifier)
    }
}
