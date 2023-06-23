//
//  MoEngageCardDecodingTest.swift
//  MoEngagePluginCards-Unit-UnitTests
//
//  Created by Soumya Mahunt on 22/06/23.
//

import XCTest
import MoEngageCards
@testable import MoEngagePluginCards

final class MoEngageCardDecodingTest: XCTestCase {

    func testCardsCategoryDataDecode() throws {
        let json = """
{
  "category": "Announcements"
}
""".data(using: .utf8)!
        guard
            let data = try JSONSerialization.jsonObject(with: json) as? [String: Any]
        else {
            XCTFail("Invalid JSON input")
            return
        }
        let cardCategory = try MoEngageCardsCategoryData.decodeFromHybrid(data)
        XCTAssertEqual(cardCategory.category, "Announcements")
    }

    func testCardsCategoryDataDecodingFailureScenario() throws {
        XCTExpectFailure("Decoding failure due to invalid data")
        let cardCategory = try try MoEngageCardsCategoryData.decodeFromHybrid([:])
    }

    func testCardClickDataDecodeWithWidgetId() throws {
        let json = """
{
  "widgetId": 1,
  "card": \(String(data: MoEngageCardCampaignTest.json, encoding: .utf8)!)
}
""".data(using: .utf8)!
        guard
            let data = try JSONSerialization.jsonObject(with: json) as? [String: Any]
        else {
            XCTFail("Invalid JSON input")
            return
        }
        let cardClick = try MoEngageCardClickData.decodeFromHybrid(data)
        XCTAssertEqual(cardClick.widgetId, 1)
        XCTAssertNotNil(cardClick.card)
        XCTAssertTrue(cardClick.card.shouldShow)
        XCTAssertEqual(cardClick.card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
        XCTAssertEqual(cardClick.card.category, "Announcements")
    }

    func testCardClickDataDecodeWithoutWidgetId() throws {
        let json = """
{
  "card": \(String(data: MoEngageCardCampaignTest.json, encoding: .utf8)!)
}
""".data(using: .utf8)!
        guard
            let data = try JSONSerialization.jsonObject(with: json) as? [String: Any]
        else {
            XCTFail("Invalid JSON input")
            return
        }
        let cardClick = try MoEngageCardClickData.decodeFromHybrid(data)
        XCTAssertNil(cardClick.widgetId)
        XCTAssertNotNil(cardClick.card)
        XCTAssertTrue(cardClick.card.shouldShow)
        XCTAssertEqual(cardClick.card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
        XCTAssertEqual(cardClick.card.category, "Announcements")
    }

    func testCardClickDataDecodeWithoutWidgetIdInAndroidFormat() throws {
        let json = """
{
  "widgetId": -1,
  "card": \(String(data: MoEngageCardCampaignTest.json, encoding: .utf8)!)
}
""".data(using: .utf8)!
        guard
            let data = try JSONSerialization.jsonObject(with: json) as? [String: Any]
        else {
            XCTFail("Invalid JSON input")
            return
        }
        let cardClick = try MoEngageCardClickData.decodeFromHybrid(data)
        XCTAssertNil(cardClick.widgetId)
        XCTAssertNotNil(cardClick.card)
        XCTAssertTrue(cardClick.card.shouldShow)
        XCTAssertEqual(cardClick.card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
        XCTAssertEqual(cardClick.card.category, "Announcements")
    }

    func testCardClickDataDecodingFailureScenario() throws {
        XCTExpectFailure("Decoding failure due to invalid data")
        let cardClick = try try MoEngageCardClickData.decodeFromHybrid([:])
    }
}
