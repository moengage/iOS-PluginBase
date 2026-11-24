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
    /// Use it for any failure reason: a shared one, a module specific one, or one found by the
    /// bridge itself, such as a missing app identifier. The reason is also the message when the
    /// message is empty. `accountMeta.appId` is empty when the identifier could not be read
    /// from the request.
    ///
    /// - Parameters:
    ///   - identifier: The workspace id the request was made for, `nil` when it is missing.
    ///   - reason: The hybrid failure reason, e.g. `MoEngagePluginConstants.FailureReason.unknownError`.
    ///   - message: The failure message, for logs.
    /// - Returns: The payload to send to the hybrid layer.
    public static func hybridFailurePayload(
        forIdentifier identifier: String?,
        reason: String,
        message: String
    ) -> [String: Any] {
        return hybridPayload(
            forIdentifier: identifier ?? "",
            data: [
                MoEngagePluginConstants.General.reason: reason,
                MoEngagePluginConstants.General.message: message.isEmpty ? reason : message
            ]
        )
    }

    /// Builds the failure reply for a native request failure with a shared SDK failure code.
    ///
    /// The reason is the shared hybrid failure reason for the failure's code.
    ///
    /// - Parameters:
    ///   - identifier: The workspace id the request was made for, `nil` when it is missing.
    ///   - failure: The failure to report.
    /// - Returns: The payload to send to the hybrid layer.
    public static func hybridFailurePayload(
        forIdentifier identifier: String?,
        failure: MoEngageRequestFailure
    ) -> [String: Any] {
        // The code itself prints as `Code(rawValue: n)`, so the readable reason is the message fallback.
        return hybridFailurePayload(
            forIdentifier: identifier,
            reason: hybridReason(forSharedCode: failure.reason.code),
            message: failure.message
        )
    }
}
