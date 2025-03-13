//
//  PushClickPayloadTest.swift
//  MoEngagePluginBaseTests
//
//  Created by Uday Kiran on 13/03/25.
//

import XCTest
@testable import MoEngagePluginBase

final class PushClickPayloadTest: XCTestCase {
    func testWithoutDefaultActionInPayload() {
        guard let pushPayloadWithoutDefaultAction = try? JSONSerialization.jsonObject(with: pushPayloadDataWithoutDefaultAction) as? [AnyHashable: Any] else {
            XCTFail("Error in PushPayload Serialization")
            return
        }
        
        
        let pushPayload = MoEngagePluginUtils.createPushClickPayload(withScreenName: nil, kvPairs: nil, andPushPayload: pushPayloadWithoutDefaultAction, identifier: "abcd")
        
        guard let data = pushPayload[MoEngagePluginConstants.General.data] as? [String: Any],
              let defaultAction = data[MoEngagePluginConstants.Push.isDefaultAction] as? Bool else {
            XCTFail("Data Dictionary/DefaultAction is Nil")
            return
        }
        XCTAssertFalse(defaultAction)
    }
    
    func testWithDefaultActionInPayload() {
        guard let pushPayloadWithDefaultAction = try? JSONSerialization.jsonObject(with: pushPayloadDataWithDefaultAction) as? [AnyHashable: Any] else {
            XCTFail("Error in PushPayload Serialization")
            return
        }
        
        let pushPayload = MoEngagePluginUtils.createPushClickPayload(withScreenName: nil, kvPairs: nil, andPushPayload: pushPayloadWithDefaultAction, identifier: "abcd")
        
        guard let data = pushPayload[MoEngagePluginConstants.General.data] as? [String: Any],
              let defaultAction = data[MoEngagePluginConstants.Push.isDefaultAction] as? Bool else {
            XCTFail("Data Dictionary/DefaultAction is Nil")
            return
        }
        
        XCTAssertTrue(defaultAction)
    }
}

let pushPayloadDataWithoutDefaultAction = """
{
  "moengage": {
    "moe_campaign_channel": "Push",
    "campaign_version_no": 1,
    "moe_campaign_id": "000000000000000030328270",
    "media-type": "image",
    "moe_delivery_type": "One Time",
    "cid": "000000000000000030328270_L_0",
    "app_id": "DAO6UGZ73D9RTK8B5W96TPYN_DEBUG",
    "media-attachment": "https://cdn.pixabay.com/photo/2016/10/21/09/25/rocks-1757593_1280.jpg"
  },
  "app_extra": {},
  "moe_push_service": "apns",
  "moeFeatures": {
    "richPush": {
      "displayName": "StylizedBasic",
      "subtitle": "Subtitle",
      "ios": {
        "category": "MOE_PUSH_TEMPLATE"
      },
      "expanded": {
        "type": "stylizedBasic",
        "autoStart": true,
        "cards": [
          {
            "widgets": [
              {
                "type": "image",
                "content": "https://cdn.pixabay.com/photo/2016/10/21/09/25/rocks-1757593_1280.jpg",
                "id": 0
              }
            ],
            "id": 0,
            "type": "stylizedBasic"
          }
        ]
      },
      "title": "Message",
      "body": "<div>msg</div>",
      "defaultActions": [
        {}
      ]
    }
  },
  "aps": {
    "mutable-content": 1,
    "alert": {
      "body": "msg",
      "title": "Message",
      "subtitle": "Subtitle"
    },
    "interruption-level": "active",
    "relevance-score": 0.5,
    "badge": 0,
    "category": "MOE_PUSH_TEMPLATE",
    "sound": "default"
  },
  "moe_cid_attr": {
    "sent_epoch_time": 1741849950
  }
}
""".data(using: .utf8)!


let pushPayloadDataWithDefaultAction = """
{
  "moengage": {
    "campaign_version_no": 1,
    "cid": "000000000000000047845195_L_0",
    "webUrl": "https://www.google.com/",
    "moe_campaign_id": "000000000000000047845195",
    "media-type": "image",
    "moe_delivery_type": "One Time",
    "moe_campaign_channel": "Push",
    "media-attachment": "https://cdn.pixabay.com/photo/2016/10/21/09/25/rocks-1757593_1280.jpg",
    "app_id": "DAO6UGZ73D9RTK8B5W96TPYN_DEBUG"
  },
  "aps": {
    "badge": 0,
    "interruption-level": "active",
    "mutable-content": 1,
    "relevance-score": 0.5,
    "sound": "default",
    "alert": {
      "body": "msg",
      "subtitle": "Subtitle",
      "title": "Message"
    },
    "category": "MOE_PUSH_TEMPLATE"
  },
  "app_extra": {},
  "moe_push_service": "apns",
  "moe_cid_attr": {
    "sent_epoch_time": 1741850044
  },
  "moeFeatures": {
    "richPush": {
      "displayName": "StylizedBasic",
      "subtitle": "Subtitle",
      "ios": {
        "category": "MOE_PUSH_TEMPLATE"
      },
      "expanded": {
        "type": "stylizedBasic",
        "autoStart": true,
        "cards": [
          {
            "widgets": [
              {
                "type": "image",
                "content": "https://cdn.pixabay.com/photo/2016/10/21/09/25/rocks-1757593_1280.jpg",
                "id": 0
              }
            ],
            "id": 0,
            "type": "stylizedBasic"
          }
        ]
      },
      "title": "Message",
      "body": "<div>msg</div>",
      "defaultActions": [
        {
          "name": "navigate",
          "type": "richLanding",
          "value": "https://www.google.com/"
        }
      ]
    }
  }
}
""".data(using: .utf8)!

