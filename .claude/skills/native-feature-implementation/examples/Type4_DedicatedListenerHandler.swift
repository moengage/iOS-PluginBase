// Type 4 — Dedicated listener handler
// Use when: native result is delivered via a feature-specific SDK listener protocol
// requiring a dedicated NSObject subclass — not the standard flushMessage pipeline.
// Example: MoEngagePluginAuthenticationListenerHandler for JWT auth errors

// ── STEP 1: Create a new file MoEngagePlugin<Feature>ListenerHandler.swift ───

import Foundation
import MoEngageSDK

@available(iOSApplicationExtension, unavailable)
final class MoEngagePlugin<Feature>ListenerHandler: NSObject, MoEngage<Feature>Error.Listener {

    private let identifier: String

    private var messageHandler: MoEngagePluginMessageHandler? {
        return MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
    }

    init(identifier: String) {
        self.identifier = identifier
        super.init()
        registerListenerInSDK()
    }

    // Registers self as the listener with the native SDK at init time.
    private func registerListenerInSDK() {
        MoEngageSDK<Framework>.sharedInstance.register<Feature>Listener(self, workspaceId: identifier)
    }

    // Implement the protocol method — fires when SDK delivers the async result:
    func onError(_ error: MoEngage<Feature>Error) {
        if let message = MoEngagePluginUtils.<featureErrorToJSON>(error: error) {
            messageHandler?.flushMessage(
                eventName: MoEngagePluginConstants.CallBackEvents.<eventName>,
                message: message
            )
        }
    }
}

// ── Real example — MoEngagePluginAuthenticationListenerHandler ────────────────

@available(iOSApplicationExtension, unavailable)
final class MoEngagePluginAuthenticationListenerHandler: NSObject, MoEngageAuthenticationError.Listener {

    private let identifier: String

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

// ── STEP 2: Bridge method in MoEngagePluginBridge.swift ───────────────────────
// The bridge method instantiates the listener handler (which registers itself
// with the SDK via registerListenerInSDK in init), then calls the native method.

@objc public func <methodName>(_ payload: [String: Any]) {
    if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload),
       let nativeModel = MoEngagePluginUtils.<payloadToNativeModel>(payload: payload) {
        _ = MoEngagePlugin<Feature>ListenerHandler(identifier: identifier)
        MoEngageSDK<Framework>.sharedInstance.<nativeMethod>(nativeModel, workspaceId: identifier)
    } else {
        MoEngageLogger.logDefault(logLevel: .error, message: "Failed to map <Feature> payload: unsupported type or missing AppID")
    }
}
