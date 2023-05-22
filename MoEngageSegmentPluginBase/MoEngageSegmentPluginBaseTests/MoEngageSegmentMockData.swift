//
//  MoEngageSegmentMockData.swift
//  MoEngageSegmentPluginBaseTests
//
//  Created by Rakshitha on 22/05/23.
//

import Foundation


struct MoEngageSegmentMockData {
    
    struct AppIdData {
        static let appId = "1234"
        static let emptyAppId = ""
    }

    struct AliasData {
        static let aliasValue = "alias Id"
        static let emptyAliasValue = ""
    }
    
    struct AnonymousIdData {
        static let id = "12344"
        static let emptyId = ""
    }

    struct EventPropertiesData {
        static let payload = ["properties": ["id": 321,"name": "iPhone","purchaseTime": "2020-06-10T12:42:10Z","billAmount": 12312.12,"userDetails": ["userName": "moengage","email": "moengage@test.com","phone": "1234567890","gender": "male"]]]
        static let emptyPayload = ["properties": []]
    }
    
    struct CustomDateData {
        static let date = "2020-06-10T12:42:10Z"
        static let invalidDateFormat = "2020-06-10T12:42Z"
        static let invalidDateType = "abcd"
    }
}
