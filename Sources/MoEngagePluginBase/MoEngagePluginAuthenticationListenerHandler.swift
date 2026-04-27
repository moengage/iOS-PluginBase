//
//  MoEngagePluginAuthenticationListenerHandler.swift
//  MoEngagePlugin
//

import Foundation
import MoEngageSDK


@available(iOSApplicationExtension, unavailable)
final class MoEngagePluginAuthenticationListenerHandler: NSObject, MoEngageAuthenticationError.Listener {

    private let  identifier: String

    private var messageHandler: MoEngagePluginMessageHandler? {
        return MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
    }

    init(identifier: String) {
        self.identifier = identifier
        super.init()
        registerListenerInSDK()
    }

    private func registerListenerInSDK() {
        MoEngageSDKCore.sharedInstance.registerAuthenticationListener(self, workspaceId: identifier)
    }

    func onError(_ error: MoEngageAuthenticationError) {
        if let message = MoEngagePluginUtils.authenticationErrorToJSON(error: error) {
            messageHandler?.flushMessage(
                eventName: MoEngagePluginConstants.CallBackEvents.authenticationError,
                message: message
            )
        }
    }
}

