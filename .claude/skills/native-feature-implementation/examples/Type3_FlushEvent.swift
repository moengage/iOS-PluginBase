// Type 3 — Flush event via standard message handler
// Use when: native result is delivered asynchronously via MoEngagePluginBridgeDelegate / flushMessage.
// Example: getSelfHandledInApp, resetUser

@objc public func <methodName>(_ payload: [String: Any]) {
    if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload) {
        #if os(tvOS)
        MoEngageLogger.logDefault(message: "<MethodName> is unavailable for tvOS 🛑")
        #else
        MoEngageSDK<Framework>.sharedInstance.<nativeMethod>(forAppId: identifier) { result, accountMeta in
            let messageHandler = MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
            let message = MoEngagePluginUtils.<mapResultToJSON>(result: result, identifier: identifier)
            messageHandler?.flushMessage(
                eventName: MoEngagePluginConstants.CallBackEvents.<eventName>,
                message: message
            )
        }
        #endif
    }
}
