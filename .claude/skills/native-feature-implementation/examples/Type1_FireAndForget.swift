// Type 1 — Fire and forget
// Use when: native API returns Void, no nativeToHybrid contract file.
// Example: showNudge, setDeviceAttribute, disableInApps
// RULE: always pass identifier to the native API — label varies (forAppId:, for:, workspaceId:)

@objc public func <methodName>(_ payload: [String: Any]) {
    if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload) {
        #if os(tvOS)
        MoEngageLogger.logDefault(message: "<MethodName> is unavailable for tvOS 🛑")
        #else
        // Use the label from the native signature — forAppId:, for:, or workspaceId:
        MoEngageSDK<Framework>.sharedInstance.<nativeMethod>(forAppId: identifier)
        #endif
    }
}

// Real example — disableInApps
@objc public func disableInApps(_ payload: [String: Any]) {
    if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload) {
        MoEngageSDKInApp.sharedInstance.disableInApps(forAppId: identifier)
    }
}

// Real example — passAuthenticationDetails (has extra param beyond identifier)
@objc public func passAuthenticationDetails(_ authenticationDetails: [String: Any]) {
    if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: authenticationDetails),
       let authDetails = MoEngagePluginUtils.authPayloadToNativeModel(payload: authenticationDetails) {
        MoEngageSDKCore.sharedInstance.passAuthenticationDetails(authDetails, workspaceId: identifier)
        MoEngageLogger.logDefault(logLevel: .verbose, message: "Authentication details passed for identifier: \(identifier)")
    } else {
        MoEngageLogger.logDefault(logLevel: .error, message: "Failed to map Authentication details unsupported type or missing AppID")
    }
}
