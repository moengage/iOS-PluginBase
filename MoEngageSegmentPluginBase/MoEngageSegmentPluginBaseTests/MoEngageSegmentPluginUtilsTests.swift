//
//  MoEngageSegmentPluginUtilsTests.swift
//  MoEngageSegmentPluginBaseTests
//
//  Created by Rakshitha on 11/05/23.
//

import XCTest
@testable import MoEngageSegmentPluginBase

final class MoEngageSegmentPluginUtilsTests: XCTestCase {
    
    override func setUp() {
       super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: App Identifier
    func test_fetch_identifier_from_payload() {
        let appId = "123"
        let idPayload =  ["accountMeta": [ "appId": appId]]
        let appId2 = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: idPayload)
        XCTAssertEqual(appId, appId2)
    }

    func test_fetch_identifier_with_empty_string() {
        let appId = ""
        let idPayload =  ["accountMeta": [ "appId": appId]]
        let appId2 = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: idPayload)
        XCTAssertNil(appId2)
    }
    
    func test_fetch_identifier_with_nil_value() {
        let appId: String? = nil
        let idPayload =  ["accountMeta": [ "appId": appId]]
        let appId2 = MoEngageSegmentPluginUtils.fetchIdentifierFromPayload(attribute: idPayload)
        XCTAssertNil(appId2)
    }
    
    // MARK: Fetch Epoch Date
    func test_epoch_date() {
        let str = "2020-06-10T12:42:10Z"
        let epochDate = MoEngageSegmentPluginUtils.fetchEpochDateFromString(value: str)
        XCTAssertEqual(epochDate?.timeIntervalSince1970, 1591792930.0)
    }
    
    func test_epoch_date_with_invalid_string() {
        let str = "abcd"
        let epochDate = MoEngageSegmentPluginUtils.fetchEpochDateFromString(value: str)
        XCTAssertNil(epochDate)
    }
    
    func test_epoch_date_with_invalid_format() {
        let str = "2020-06-10T12:42Z"
        let epochDate = MoEngageSegmentPluginUtils.fetchEpochDateFromString(value: str)
        XCTAssertNil(epochDate)
    }
}

