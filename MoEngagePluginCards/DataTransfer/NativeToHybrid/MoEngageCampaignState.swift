//
//  MoEngageCampaignState.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCampaignState: HybridEncodable {
    enum HybridKeys {
        static let showCountTotal = "totalShowCount"
        static let isClicked = "isClicked"
        static let firstSeenTime = "firstSeen"
        static let firstDeliveredTime = "firstReceived"
        static let showCountCurrentDevice = "localShowCount"
    }

    func encodeForHybrid() -> [String: Any?] {
        return [
            HybridKeys.showCountTotal: self.showCountTotal,
            HybridKeys.isClicked: self.isClicked,
            HybridKeys.firstSeenTime: self.firstSeenTime?.timeIntervalSince1970,
            HybridKeys.firstDeliveredTime: self.firstDeliveredTime?.timeIntervalSince1970,
            HybridKeys.showCountCurrentDevice: self.showCountCurrentDevice,
        ]
    }
}
