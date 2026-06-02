// Type 2 — Completion handler
// Use when: native API has a trailing completionHandler/completionBlock closure.
// Example: getSelfHandledInApps, getUserIdentities, fetchCards

@objc public func <methodName>(_ payload: [String: Any], completionBlock: @escaping (([String: Any]) -> Void)) {
    if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload) {
        MoEngageSDK<Framework>.sharedInstance.<nativeMethod>(forAppId: identifier) { result in
            let responsePayload = MoEngagePluginUtils.<mapResultToJSON>(result: result)
            completionBlock(responsePayload)
        }
    } else {
        completionBlock([:])
    }
}
