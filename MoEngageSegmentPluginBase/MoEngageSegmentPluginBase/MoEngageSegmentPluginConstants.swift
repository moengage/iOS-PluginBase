//
//  MoEngageSegmentPluginConstants.swift
//  MoEngageSegmentPluginBase
//
//  Created by Rakshitha on 09/05/23.
//

import Foundation

struct MoEngageSegmentPluginConstants {
    
    private init() {
    }
    
    struct General {
        static let accountMeta = "accountMeta"
        static let data = "data"
        static let appId = "appId"
    }
    
    // user attribute
    public struct UserAttribute {
        static let traits = "traits"
        static let alias = "alias"
        static let anonymousId = "anonymousId"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let location = "location"
        static let segmentId = "USER_ATTRIBUTE_SEGMENT_ID"
    }
    
    // event
    struct EventTracking {
        static let event = "event"
        static let properties = "properties"
    }
}
