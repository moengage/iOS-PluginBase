//
//  MoEngageSegmentPluginUtils.swift
//  MoEngageSegmentPluginBase
//
//  Created by Rakshitha on 09/05/23.
//

import Foundation
import MoEngageSDK

class MoEngageSegmentPluginUtils {
    
    static func fetchIdentifierFromPayload(attribute: [String: Any]) -> String? {
        if let accountMeta = attribute[MoEngageSegmentPluginConstants.General.accountMeta] as? [String: Any],
           let appID = accountMeta[MoEngageSegmentPluginConstants.General.appId] as? String,
           !appID.isEmpty {
            return appID
        }
        
        return nil
    }
    
    static func fetchEpochDateFromString(value: Any?) -> Date? {
        if let isoString = value as? String, let epochDate = MoEngageDateUtils.getDateFromISOString(isoString) {
            return epochDate
        }
        
        return nil
    }
}
