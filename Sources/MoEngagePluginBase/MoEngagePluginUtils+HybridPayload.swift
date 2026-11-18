//
//  MoEngagePluginUtils+HybridPayload.swift
//  MoEngagePluginBase
//

import Foundation
import MoEngageCore

extension MoEngagePluginUtils {

    /// Builds the success reply for the hybrid layer: `{ accountMeta, data }`.
    ///
    /// - Parameters:
    ///   - identifier: The workspace id the request was made for.
    ///   - data: The success data defined by the feature's contract.
    /// - Returns: The payload to send to the hybrid layer.
    public static func hybridPayload(forIdentifier identifier: String, data: [String: Any]) -> [String: Any] {
        return [
            MoEngagePluginConstants.General.accountMeta: createAccountPayload(identifier: identifier),
            MoEngagePluginConstants.General.data: data
        ]
    }

    /// Builds the failure reply for the hybrid layer: `{ accountMeta, data: { reason, message } }`.
    ///
    /// The reason is the shared hybrid failure reason for the failure's code, and it is also the
    /// message when the failure has none. `accountMeta.appId` is empty when the identifier could
    /// not be read from the request.
    ///
    /// - Parameters:
    ///   - identifier: The workspace id the request was made for, `nil` when it is missing.
    ///   - failure: The failure to report.
    /// - Returns: The payload to send to the hybrid layer.
    public static func hybridFailurePayload(
        forIdentifier identifier: String?,
        failure: MoEngageRequestFailure
    ) -> [String: Any] {
        let reason = hybridReason(forSharedCode: failure.reason.code)
        // The code itself prints as `Code(rawValue: n)`, so the readable reason is the fallback.
        let message = failure.message.isEmpty ? reason : failure.message
        return hybridPayload(
            forIdentifier: identifier ?? "",
            data: [
                MoEngagePluginConstants.General.reason: reason,
                MoEngagePluginConstants.General.message: message
            ]
        )
    }
}
