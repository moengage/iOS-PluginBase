//
//  MoEngageSegmentPluginBaseTests.swift
//  MoEngageSegmentPluginBaseTests
//
//  Created by Rakshitha on 11/05/23.
//

import XCTest
@testable import MoEngageSegmentPluginBase

final class MoEngageSegmentPluginParserTests: XCTestCase {
    override func setUp() {
       super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Alias Parsing
    func test_fetch_alias() {
        let aliasPayload =  ["accountMeta": [ "appId": MoEngageSegmentMockData.AppIdData.appId], "data": ["alias": MoEngageSegmentMockData.AliasData.aliasValue]]
        let alias = MoEngageSegmentPluginParser().fetchAlias(payload: aliasPayload)
        XCTAssertEqual(alias, MoEngageSegmentMockData.AliasData.aliasValue)
    }

    func test_fetch_alias_with_empty_string() {
        let aliasValue = MoEngageSegmentMockData.AliasData.emptyAliasValue
        let aliasPayload =  ["accountMeta": [ "appId": MoEngageSegmentMockData.AppIdData.appId], "data": ["alias": aliasValue]]
        let alias = MoEngageSegmentPluginParser().fetchAlias(payload: aliasPayload)
        XCTAssertNil(alias)
    }
    
    func test_fetch_alias_with_nil_value() {
        let aliasValue: String? = nil
        let aliasPayload =  ["accountMeta": [ "appId": MoEngageSegmentMockData.AppIdData.appId], "data": ["alias": aliasValue]]
        let alias = MoEngageSegmentPluginParser().fetchAlias(payload: aliasPayload)
        XCTAssertNil(alias)
    }
    
    // MARK: Fetch anonymous id
    
    func test_fetch_anonymous_id() {
        let id = MoEngageSegmentMockData.AnonymousIdData.id
        let idPayload =  ["accountMeta": [ "appId": MoEngageSegmentMockData.AppIdData.appId], "data": ["anonymousId": id]]
        let anonymousId = MoEngageSegmentPluginParser().fetchAnonymousId(payload: idPayload)
        XCTAssertEqual(id, anonymousId)
    }

    func test_fetch_anonymous_id_with_empty_string() {
        let id =  MoEngageSegmentMockData.AnonymousIdData.emptyId
        let idPayload =  ["accountMeta": [ "appId": MoEngageSegmentMockData.AppIdData.appId], "data": ["anonymousId": id]]
        let anonymousId = MoEngageSegmentPluginParser().fetchAnonymousId(payload: idPayload)
        XCTAssertNil(anonymousId)
    }
    
    func test_fetch_anonymous_with_nil_value () {
        let id: String? = nil
        let idPayload =  ["accountMeta": [ "appId": MoEngageSegmentMockData.AppIdData.appId], "data": ["anonymousId": id]]
        let anonymousId = MoEngageSegmentPluginParser().fetchAnonymousId(payload: idPayload)
        XCTAssertNil(anonymousId)
    }
    
    // MARK: Event properties
    
    func test_fetch_event_properties() {
        let payload = MoEngageSegmentMockData.EventPropertiesData.payload as [String : Any]
        let properties = MoEngageSegmentPluginParser().fetchEventProperties(payload: payload)
        XCTAssertNotNil(properties)
    }
    
    func test_fetch_event_with_empty_payload() {
        let payload = MoEngageSegmentMockData.EventPropertiesData.emptyPayload
        let properties = MoEngageSegmentPluginParser().fetchEventProperties(payload: payload)
        XCTAssertNotNil(properties)
    }

}
