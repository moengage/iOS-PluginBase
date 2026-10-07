//
//  MoEngagePluginUnsetUserAttributeTests.swift
//  MoEngagePluginBaseTests
//

import Foundation
import Testing
import MoEngageCore
@testable import MoEngagePluginBase

// Keys are written as literals so the tests pin the hybrid contract strings
@Suite("Unset user attribute")
struct MoEngagePluginUnsetUserAttributeTests {
    private let appId = "TEST_APP_ID"

    // MARK: Parser

    @Test("Parser reads the name and the portfolio level")
    func parserReadsNameAndPortfolioLevel() {
        let data = MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: payload(name: "loyalty_tier", level: "portfolio"))
        #expect(data.name == "loyalty_tier")
        #expect(data.level == .portfolio)
    }

    @Test("Other levels fall back to project", arguments: ["project", "PORTFOLIO", "abc", nil] as [String?])
    func parserDefaultsToProjectLevel(level: String?) {
        let data = MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: payload(name: "trial_status", level: level))
        #expect(data.level == .project)
    }

    @Test("A missing name is passed on as empty")
    func parserPassesMissingNameAsEmpty() {
        #expect(MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: [:]).name == "")
        #expect(MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: payload(name: nil, level: nil)).name == "")
    }

    // MARK: Result payload

    @Test("Success payload matches the contract")
    func successPayloadMatchesContract() {
        let json = MoEngagePluginUtils.unsetUserAttributeResultToJSON(attributeName: "trial_status", attributeLevel: .project, identifier: appId)
        let expected: [String: Any] = [
            "accountMeta": ["appId": appId],
            "data": ["isUnsetSuccess": true, "attributeName": "trial_status", "attributeLevel": "project"]
        ]
        #expect(json as NSDictionary == expected as NSDictionary)
    }

    @Test("Portfolio level is echoed")
    func portfolioLevelIsEchoed() {
        let json = MoEngagePluginUtils.unsetUserAttributeResultToJSON(attributeName: "loyalty_tier", attributeLevel: .portfolio, identifier: appId)
        let data = json["data"] as? [String: Any]
        #expect(data?["attributeLevel"] as? String == "portfolio")
    }

    @Test("Failure payload matches the contract")
    func failurePayloadMatchesContract() {
        let failure = MoEngageRequestFailure(reason: MoEngageRequestFailureReason(code: .invalidParameters), message: "Attribute name is empty.")
        let json = MoEngagePluginUtils.unsetUserAttributeResultToJSON(attributeName: "", attributeLevel: .project, failure: failure, identifier: appId)
        let expected: [String: Any] = [
            "accountMeta": ["appId": appId],
            "data": [
                "isUnsetSuccess": false,
                "attributeName": "",
                "attributeLevel": "project",
                "failure": ["reason": "INVALID_PARAMETERS", "message": "Attribute name is empty."]
            ]
        ]
        #expect(json as NSDictionary == expected as NSDictionary)
    }

    // MARK: Failure reasons

    @Test("Shared codes use the common mapping", arguments: [.invalidParameters, .sdkNotInitialized, .featureDisabled, .unknownError] as [MoEngageRequestFailureReason.Code])
    func sharedCodesUseCommonMapping(code: MoEngageRequestFailureReason.Code) {
        #expect(reason(for: MoEngageRequestFailureReason(code: code)) == MoEngagePluginUtils.hybridReason(forSharedCode: code))
    }

    @Test("Core module code is checked before the shared code")
    func coreModuleCodeIsCheckedBeforeSharedCode() {
        let coreReason = MoEngageCoreRequestFailureReason(moduleCode: .invalidInitialisationConfiguration)
        #expect(coreReason.code == .invalidParameters)
        #expect(reason(for: coreReason) == "INVALID_INITIALISATION_CONFIGURATION")
    }

    @Test("Core sdkState module code maps to SDK_STATE")
    func coreSdkStateModuleCodeMapsToSdkState() {
        let coreReason = MoEngageCoreRequestFailureReason(moduleCode: .sdkState)
        #expect(coreReason.code == .featureDisabled)
        #expect(reason(for: coreReason) == "SDK_STATE")
    }

    @Test("Core reason without a module code uses the shared code")
    func coreReasonWithoutModuleCodeUsesSharedCode() {
        #expect(reason(for: MoEngageCoreRequestFailureReason(code: .sdkNotInitialized)) == "SDK_STATE")
    }

    // MARK: Bridge

    @Test("Missing app id replies with an SDK_STATE failure")
    func missingAppIdRepliesWithSdkStateFailure() {
        var reply: [String: Any]?
        let payload: [String: Any] = ["data": ["attributeName": "trial_status", "attributeLevel": "portfolio"]]
        MoEngagePluginBridge.sharedInstance.unsetUserAttribute(payload) { reply = $0 }
        let expected: [String: Any] = [
            "accountMeta": ["appId": ""],
            "data": [
                "isUnsetSuccess": false,
                "attributeName": "trial_status",
                "attributeLevel": "portfolio",
                "failure": ["reason": "SDK_STATE", "message": "App identifier missing in payload"]
            ]
        ]
        #expect(reply as NSDictionary? == expected as NSDictionary)
    }

    // MARK: Helpers

    private func payload(name: String?, level: String?) -> [String: Any] {
        var data = [String: Any]()
        data["attributeName"] = name
        data["attributeLevel"] = level
        return ["accountMeta": ["appId": appId], "data": data]
    }

    private func reason(for reason: MoEngageRequestFailureReason) -> String? {
        let failure = MoEngageRequestFailure(reason: reason)
        let json = MoEngagePluginUtils.unsetUserAttributeResultToJSON(attributeName: "name", attributeLevel: .project, failure: failure, identifier: appId)
        let data = json["data"] as? [String: Any]
        let failurePayload = data?["failure"] as? [String: Any]
        return failurePayload?["reason"] as? String
    }
}
