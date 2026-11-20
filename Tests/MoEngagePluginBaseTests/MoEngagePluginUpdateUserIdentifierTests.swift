//
//  MoEngagePluginUpdateUserIdentifierTests.swift
//  MoEngagePluginBaseTests
//

import Foundation
import Testing
import MoEngageCore
@testable import MoEngagePluginBase

// Keys are written as literals so the tests pin the hybrid contract strings
@Suite("Update user identifier")
struct MoEngagePluginUpdateUserIdentifierTests {
    private let appId = "TEST_APP_ID"

    // MARK: Success payload

    @Test("Success payload matches the contract")
    func successPayloadMatchesContract() {
        let payload = MoEngagePluginUtils.hybridPayload(
            forIdentifier: appId,
            data: ["identities": ["uid": "user-1", "u_em": "a@b.com"]]
        )
        #expect(accountMetaAppId(payload) == appId)
        #expect(data(payload)?["identities"] as? [String: String] == ["uid": "user-1", "u_em": "a@b.com"])
    }

    // MARK: Failure payload

    @Test(
        "Shared failure codes map to the contract reasons",
        arguments: [
            (MoEngageRequestFailureReason.Code.sdkNotInitialized, "SDK_STATE"),
            (.featureDisabled, "FEATURE_DISABLED"),
            (.invalidParameters, "INVALID_PARAMETERS"),
            (.unknownError, "UNKNOWN_ERROR"),
            // Shared codes with no hybrid reason of their own are reported as UNKNOWN_ERROR
            (.cancelled, "UNKNOWN_ERROR"),
            (.requiredPermissionMissing, "UNKNOWN_ERROR")
        ]
    )
    func failurePayloadMapsReason(code: MoEngageRequestFailureReason.Code, expectedReason: String) {
        let failure = MoEngageRequestFailure(reason: MoEngageRequestFailureReason(code: code), message: "reason message")
        let payload = MoEngagePluginUtils.hybridFailurePayload(forIdentifier: appId, failure: failure)
        #expect(accountMetaAppId(payload) == appId)
        #expect(data(payload)?["reason"] as? String == expectedReason)
        #expect(data(payload)?["message"] as? String == "reason message")
    }

    @Test("Failure payload without an identifier has an empty appId")
    func failurePayloadWithoutIdentifier() {
        let failure = MoEngageRequestFailure(reason: MoEngageRequestFailureReason(code: .unknownError), message: "missing")
        let payload = MoEngagePluginUtils.hybridFailurePayload(forIdentifier: nil, failure: failure)
        #expect(accountMetaAppId(payload) == "")
        #expect(data(payload)?["reason"] as? String == "UNKNOWN_ERROR")
    }

    @Test("An empty failure message falls back to the reason")
    func failurePayloadMessageFallback() {
        let failure = MoEngageRequestFailure(reason: MoEngageRequestFailureReason(code: .featureDisabled), message: "")
        let payload = MoEngagePluginUtils.hybridFailurePayload(forIdentifier: appId, failure: failure)
        #expect(data(payload)?["message"] as? String == "FEATURE_DISABLED")
    }

    @Test("A reason given directly is passed through with its message")
    func failurePayloadWithReason() {
        let payload = MoEngagePluginUtils.hybridFailurePayload(
            forIdentifier: nil,
            reason: "UNKNOWN_ERROR",
            message: "Couldn't find app identifier in payload"
        )
        #expect(accountMetaAppId(payload) == "")
        #expect(data(payload)?["reason"] as? String == "UNKNOWN_ERROR")
        #expect(data(payload)?["message"] as? String == "Couldn't find app identifier in payload")
    }

    @Test("A reason given directly is also the message when the message is empty")
    func failurePayloadWithReasonMessageFallback() {
        let payload = MoEngagePluginUtils.hybridFailurePayload(forIdentifier: appId, reason: "SDK_STATE", message: "")
        #expect(accountMetaAppId(payload) == appId)
        #expect(data(payload)?["message"] as? String == "SDK_STATE")
    }

    // MARK: Parser

    @Test("Only string identity values are used")
    func parserKeepsOnlyStringValues() {
        let identities = MoEngagePluginParser.fetchIdentities(
            payload: request(identity: ["uid": "user-1", "u_mb": 98765, "flag": true])
        )
        #expect(identities == ["uid": "user-1"])
    }

    @Test("A missing identity is nil")
    func parserMissingIdentity() {
        #expect(MoEngagePluginParser.fetchIdentities(payload: ["accountMeta": ["appId": appId]]) == nil)
    }

    // MARK: Bridge

    @Test("A missing appId replies UNKNOWN_ERROR exactly once")
    func bridgeMissingAppId() async {
        await confirmation(expectedCount: 1) { replied in
            MoEngagePluginBridge.sharedInstance.updateUserIdentifier(["data": ["identity": ["uid": "user-1"]]]) { reply in
                replied()
                #expect(self.accountMetaAppId(reply) == "")
                #expect(self.data(reply)?["reason"] as? String == "UNKNOWN_ERROR")
            }
        }
    }

    @Test("A workspace that is not initialized replies SDK_STATE")
    func bridgeUninitializedWorkspace() async {
        // Native stops with a fatal error for a workspace used before initialization; this
        // public hook, meant for test bundles, turns that into an sdkNotInitialized rejection.
        MoEngageSDKInstanceProvider.disablePreconditionSDKInitialized()
        // A checked continuation traps if resumed twice, so this also checks for a single reply.
        let reply = await withCheckedContinuation { continuation in
            MoEngagePluginBridge.sharedInstance.updateUserIdentifier(request(identity: ["uid": "user-1"])) { reply in
                continuation.resume(returning: reply)
            }
        }
        #expect(accountMetaAppId(reply) == appId)
        #expect(data(reply)?["reason"] as? String == "SDK_STATE")
    }

    // MARK: Helpers

    private func request(identity: [String: Any]) -> [String: Any] {
        return ["accountMeta": ["appId": appId], "data": ["identity": identity]]
    }

    private func accountMetaAppId(_ payload: [String: Any]) -> String? {
        return (payload["accountMeta"] as? [String: Any])?["appId"] as? String
    }

    private func data(_ payload: [String: Any]) -> [String: Any]? {
        return payload["data"] as? [String: Any]
    }
}
