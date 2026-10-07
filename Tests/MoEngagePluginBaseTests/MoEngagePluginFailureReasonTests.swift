//
//  MoEngagePluginFailureReasonTests.swift
//  MoEngagePluginBaseTests
//
//  Created by Rakshitha on 05/10/26.
//

import Testing
import MoEngageCore
@testable import MoEngagePluginBase

@Suite("Common failure reasons")
struct MoEngagePluginFailureReasonTests {
    typealias FailureReason = MoEngagePluginConstants.FailureReason

    @Test("Failure reasons match the hybrid contract")
    func failureReasonValues() {
        #expect(FailureReason.sdkState == "SDK_STATE")
        #expect(FailureReason.featureDisabled == "FEATURE_DISABLED")
        #expect(FailureReason.networkError == "NETWORK_ERROR")
        #expect(FailureReason.parseError == "PARSE_ERROR")
        #expect(FailureReason.invalidParameters == "INVALID_PARAMETERS")
        #expect(FailureReason.invalidInitialisationConfiguration == "INVALID_INITIALISATION_CONFIGURATION")
        #expect(FailureReason.serverError == "SERVER_ERROR")
        #expect(FailureReason.duplicateFunctionCall == "DUPLICATE_FUNCTION_CALL")
        #expect(FailureReason.authenticationFailed == "AUTHENTICATION_FAILED")
        #expect(FailureReason.unknownError == "UNKNOWN_ERROR")
    }

    @Test(
        "Shared codes map to hybrid reasons",
        arguments: [
            (MoEngageRequestFailureReason.Code.sdkNotInitialized, "SDK_STATE"),
            (.featureDisabled, "FEATURE_DISABLED"),
            (.networkError, "NETWORK_ERROR"),
            (.parseError, "PARSE_ERROR"),
            (.invalidParameters, "INVALID_PARAMETERS"),
            (.serverError, "SERVER_ERROR"),
            (.authenticationFailed, "AUTHENTICATION_FAILED"),
            (.unknownError, "UNKNOWN_ERROR"),
            (.requiredPermissionMissing, "UNKNOWN_ERROR"),
            (.cancelled, "UNKNOWN_ERROR")
        ]
    )
    func sharedCodeMapping(code: MoEngageRequestFailureReason.Code, expectedReason: String) {
        #expect(MoEngagePluginUtils.hybridReason(forSharedCode: code) == expectedReason)
    }
}
