//
//  MoEngageSegmentPluginBaseTests.swift
//  MoEngageSegmentPluginBaseTests
//
//  Created by Rakshitha on 11/05/23.
//

import XCTest
@testable import MoEngageSegmentPluginBase

final class MoEngageSegmentPluginParserTests: XCTestCase {
    let appId: String = "1234"
    
    override func setUp() {
       super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Alias Parsing
    func test_fetch_alias() {
        let aliasValue = "alias ID"
        let aliasPayload =  ["accountMeta": [ "appId": appId], "data": ["alias": aliasValue]]
        let alias = MoEngageSegmentPluginParser.fetchAlias(payload: aliasPayload)
        XCTAssertEqual(alias, aliasValue)
    }

    func test_fetch_alias_with_empty_string() {
        let aliasValue = ""
        let aliasPayload =  ["accountMeta": [ "appId": appId], "data": ["alias": aliasValue]]
        let alias = MoEngageSegmentPluginParser.fetchAlias(payload: aliasPayload)
        XCTAssertNil(alias)
    }
    
    func test_fetch_alias_with_nil_value() {
        let aliasValue: String? = nil
        let aliasPayload =  ["accountMeta": [ "appId": appId], "data": ["alias": aliasValue]]
        let alias = MoEngageSegmentPluginParser.fetchAlias(payload: aliasPayload)
        XCTAssertNil(alias)
    }
    
    // MARK: Fetch anonymous id
    
    func test_fetch_anonymous_id() {
        let id = "8899"
        let idPayload =  ["accountMeta": [ "appId": appId], "data": ["anonymousId": id]]
        let anonymousId = MoEngageSegmentPluginParser.fetchAnonymousId(payload: idPayload)
        XCTAssertEqual(id, anonymousId)
    }

    func test_fetch_anonymous_id_with_empty_string() {
        let id = ""
        let idPayload =  ["accountMeta": [ "appId": appId], "data": ["anonymousId": id]]
        let anonymousId = MoEngageSegmentPluginParser.fetchAnonymousId(payload: idPayload)
        XCTAssertNil(anonymousId)
    }
    
    func test_fetch_anonymous_with_nil_value () {
        let id: String? = nil
        let idPayload =  ["accountMeta": [ "appId": appId], "data": ["anonymousId": id]]
        let anonymousId = MoEngageSegmentPluginParser.fetchAnonymousId(payload: idPayload)
        XCTAssertNil(anonymousId)
    }
    
    // MARK: Event properties
    
    func test_fetch_event_properties() {
        let payload = ["properties": ["id": 321,"name": "iPhone","purchaseTime": "2020-06-10T12:42:10Z","billAmount": 12312.12,"userDetails": ["userName": "moengage","email": "moengage@test.com","phone": "1234567890","gender": "male"]]] as [String : Any]
        let properties = MoEngageSegmentPluginParser.fetchEventProperties(payload: payload)
        XCTAssertNotNil(properties)
    }
    
    func test_fetch_event_with_empty_payload() {
        let payload = ["properties": []]
        let properties = MoEngageSegmentPluginParser.fetchEventProperties(payload: payload)
        XCTAssertNotNil(properties)
    }

}
