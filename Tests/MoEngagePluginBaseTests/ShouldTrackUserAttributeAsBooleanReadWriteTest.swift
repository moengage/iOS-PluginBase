//
//  InitializationAndUserAttributeTrackingTest.swift
//  Pods
//
//  Created by Uday Kiran on 24/03/25.
//

import XCTest
@testable import MoEngagePluginBase

final class ShouldTrackUserAttributeAsBooleanReadWriteTest: XCTestCase {
    var initConfig: MoEngageInitConfig!
    let queue1 = DispatchQueue(label: "serialQueue")
    let expectation = XCTestExpectation(description: "ConcurrentAccess")

    override func setUp() {
        super.setUp()
        initConfig = MoEngageInitConfig(analyticsConfig: MoEngageAnalyticsConfig(shouldTrackUserAttributeBooleanAsNumber: true))
    }

    func testReadAndWriteFromDifferentThreads() async {
        let appID = "abcd"
        MoEngageInitConfigCache.sharedInstance.initializeInitConfig(appID: appID, initConfig: self.initConfig)

        let shouldTrack = await withCheckedContinuation { continuation in
            queue1.async {
                MoEngageInitConfigCache.sharedInstance.fetchShouldTrackUserAttributeBooleanAsNumber(forAppID: appID) { shouldTrack in
                    continuation.resume(returning: shouldTrack)
                }
            }
        }

        XCTAssertTrue(shouldTrack)
    }
}
