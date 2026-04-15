//
//  MoEngagePluginAuthenticationListenerHandler.swift
//  MoEngagePlugin
//

import Foundation
import MoEngageSDK

#if !os(tvOS)

@available(iOSApplicationExtension, unavailable)
@available(tvOS, unavailable)
final class MoEngagePluginAuthenticationListenerHandler: NSObject, MoEngageAuthenticationError.Listener {

    private static var handlers = [String: Any]()

    private var identifier: String

    private var messageHandler: MoEngagePluginMessageHandler? {
        return MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
    }

    init(identifier: String) {
        self.identifier = identifier
        super.init()
        registerWithSDK()
    }

    private func registerWithSDK() {
        MoEngageSDKCore.sharedInstance.registerAuthenticationListener(self, workspaceId: identifier)
        MoEngagePluginAuthenticationListenerHandler.handlers[identifier] = self
    }

    func onError(_ error: MoEngageAuthenticationError) {
        let message = MoEngagePluginUtils.authenticationErrorToJSON(error: error)
        messageHandler?.flushMessage(
            eventName: MoEngagePluginConstants.CallBackEvents.authenticationError,
            message: message
        )
    }
}

#endif
