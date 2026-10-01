//
//  MoEngagePluginUnsetUserAttributeTests.swift
//  MoEngagePluginBaseTests
//

import XCTest
import MoEngageCore
@testable import MoEngagePluginBase

// Keys are written as literals so the tests pin the hybrid contract strings
final class MoEngagePluginUnsetUserAttributeTests: XCTestCase {
    private let appId = "TEST_APP_ID"

    // MARK: Parser

    func testParserReadsNameAndPortfolioLevel() {
        let data = MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: payload(name: "loyalty_tier", level: "portfolio"))
        XCTAssertEqual(data.name, "loyalty_tier")
        XCTAssertEqual(data.level, .portfolio)
    }

    func testParserDefaultsToProjectLevel() {
        for level in ["project", "PORTFOLIO", "abc", nil] {
            let data = MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: payload(name: "trial_status", level: level))
            XCTAssertEqual(data.level, .project, "level: \(String(describing: level))")
        }
    }

    func testParserPassesMissingNameAsEmpty() {
        XCTAssertEqual(MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: [:]).name, "")
        XCTAssertEqual(MoEngagePluginParser.mapJsonToUnsetUserAttributeData(payload: payload(name: nil, level: nil)).name, "")
    }

    // MARK: Result payload

    func testSuccessPayloadMatchesContract() {
        let json = MoEngagePluginUtils.unsetUserAttributeResultToJSON(attributeName: "trial_status", attributeLevel: .project, identifier: appId)
        let expected: [String: Any] = [
            "accountMeta": ["appId": appId],
            "data": ["isUnsetSuccess": true, "attributeName": "trial_status", "attributeLevel": "project"]
        ]
        XCTAssertEqual(json as NSDictionary, expected as NSDictionary)
    }

    func testPortfolioLevelIsEchoed() {
        let json = MoEngagePluginUtils.unsetUserAttributeResultToJSON(attributeName: "loyalty_tier", attributeLevel: .portfolio, identifier: appId)
        let data = json["data"] as? [String: Any]
        XCTAssertEqual(data?["attributeLevel"] as? String, "portfolio")
    }

    func testFailurePayloadMatchesContract() {
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
        XCTAssertEqual(json as NSDictionary, expected as NSDictionary)
    }

    // MARK: Failure reasons

    func testSharedCodesMapToContractReasons() {
        let cases: [(MoEngageRequestFailureReason.Code, String)] = [
            (.invalidParameters, "INVALID_PARAMETERS"),
            (.sdkNotInitialized, "SDK_STATE"),
            (.featureDisabled, "SDK_STATE"),
            (.unknownError, "UNKNOWN_ERROR"),
            (.networkError, "UNKNOWN_ERROR")
        ]
        for (code, expected) in cases {
            XCTAssertEqual(reason(for: MoEngageRequestFailureReason(code: code)), expected, "code: \(code)")
        }
    }

    func testCoreModuleCodeIsCheckedBeforeSharedCode() {
        let coreReason = MoEngageCoreRequestFailureReason(moduleCode: .invalidInitialisationConfiguration)
        XCTAssertEqual(coreReason.code, .invalidParameters)
        XCTAssertEqual(reason(for: coreReason), "INVALID_INITIALISATION_CONFIGURATION")
    }

    func testCoreSdkStateModuleCodeMapsToSdkState() {
        let coreReason = MoEngageCoreRequestFailureReason(moduleCode: .sdkState)
        XCTAssertEqual(coreReason.code, .featureDisabled)
        XCTAssertEqual(reason(for: coreReason), "SDK_STATE")
    }

    func testCoreReasonWithoutModuleCodeUsesSharedCode() {
        XCTAssertEqual(reason(for: MoEngageCoreRequestFailureReason(code: .sdkNotInitialized)), "SDK_STATE")
    }

    // MARK: Bridge

    func testMissingAppIdRepliesWithSdkStateFailure() {
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
        XCTAssertEqual(reply as NSDictionary?, expected as NSDictionary)
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
