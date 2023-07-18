//
//  MoEngageCardDecodingTest.swift
//  MoEngagePluginCards-Unit-UnitTests
//
//  Created by Soumya Mahunt on 21/06/23.
//

import XCTest
import MoEngageCards
@testable import MoEngagePluginCards

class MoEngageCardCampaignTest: XCTestCase {
    static let json = """
{
  "card_id": "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios",
  "category": "Announcements",
  "template_data": {
    "type": "basic",
    "containers": [
      {
        "widgets": [
          {
            "content": "<div>Some header</div>",
            "type": "text",
            "id": 1
          },
          {
            "content": "<div>some message</div>",
            "type": "text",
            "id": 2
          },
          {
            "content": "<div>some action</div>",
            "type": "button",
            "id": 3,
            "actions": [
              {
                "type": "screenName",
                "name": "navigate",
                "value": "action",
                "kvPairs": {}
              }
            ]
          }
        ],
        "style": {
          "bgColor": "#b8e986"
        },
        "type": "basic",
        "id": 0,
        "actions": []
      }
    ],
    "batch_no": 0
  },
  "meta_data": {
    "campaignState": {
      "localShowCount": 1,
      "isClicked": false,
      "firstSeen": 1687083671,
      "firstReceived": 1687083671,
      "totalShowCount": 4
    },
    "display_controls": {
      "expire_at": 1689489366
    },
    "metaData": {
      "moe_campaign_id": "000000000001686897366450",
      "moe_campaign_type": "cards",
      "moe_campaign_channel": "Cards",
      "moe_delivery_type": "One Time",
      "cid": "000000000001686897366450_F_T_CA_AB_0_P_0_L_0",
      "moe_card_id": "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios",
      "moe_campaign_name": "MoEngageDemoAppMoeTest-TestCardCampaign"
    },
    "created_at": 1686897366,
    "updated_at": 1686897366,
    "campaignPayload": {
      "id": "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios",
      "platform": "ios",
      "status": "show",
      "created_at": 1686897366,
      "updated_at": 1686897366,
      "meta_data": {
        "moe_campaign_id": "000000000001686897366450",
        "moe_campaign_type": "cards",
        "moe_campaign_channel": "Cards",
        "moe_delivery_type": "One Time",
        "cid": "000000000001686897366450_F_T_CA_AB_0_P_0_L_0",
        "moe_card_id": "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios",
        "moe_campaign_name": "MoEngageDemoAppMoeTest-TestCardCampaign"
      },
      "template_data": {
        "type": "basic",
        "containers": [
          {
            "widgets": [
              {
                "content": "<div>Some header</div>",
                "type": "text",
                "id": 1
              },
              {
                "content": "<div>some message</div>",
                "type": "text",
                "id": 2
              },
              {
                "content": "<div>some action</div>",
                "type": "button",
                "id": 3,
                "actions": [
                  {
                    "type": "screenName",
                    "name": "navigate",
                    "value": "action",
                    "kvPairs": {}
                  }
                ]
              }
            ],
            "style": {
              "bgColor": "#b8e986"
            },
            "type": "basic",
            "id": 0,
            "actions": []
          }
        ],
        "batch_no": 0
      },
      "user_activity": {
        "is_clicked": false,
        "first_seen": 1687083671,
        "first_delivered": 1687083671,
        "show_count": {
          "CC2279BB-EA41-4095-BFF6-F7BFBD22D262-1685269519": 1,
          "176255C0-0ACB-4589-9293-725B447AA641-1687165810": 0,
          "028233A8-CF50-459E-B08C-D774C6FF19DE-1687173912": 0,
          "835E677B-5C13-44E7-8F87-316B28EA6D3F-1687252998": 0
        }
      },
      "display_controls": {
        "expire_at": 1689489366
      },
      "category": "Announcements"
    }
  }
}
""".data(using: .utf8)!

    func testDecodingFromHybrid() throws {
        guard
            let data = try JSONSerialization.jsonObject(with: Self.json) as? [String: Any]
        else {
            XCTFail("Invalid JSON input")
            return
        }
        let card: MoEngageCardCampaign = try MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: data)
        XCTAssertNotNil(card)
        XCTAssertTrue(card.shouldShow)
        XCTAssertEqual(card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
        XCTAssertEqual(card.category, "Announcements")
    }

    func testEncodingToHybrid() throws {
        guard
            let data = try JSONSerialization.jsonObject(with: Self.json) as? [String: Any]
        else {
            XCTFail("Invalid JSON input")
            return
        }
        let hybridData = try MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: data).encodeForHybrid()
        print(hybridData)
        let card: MoEngageCardCampaign = try MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: hybridData)
        XCTAssertNotNil(card)
        XCTAssertTrue(card.shouldShow)
        XCTAssertEqual(card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
        XCTAssertEqual(card.category, "Announcements")
    }

    func testDecodingFailureScenario() throws {
        XCTExpectFailure("Decoding failure due to invalid data")
        let card: MoEngageCardCampaign = try MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: [:])
    }
}
