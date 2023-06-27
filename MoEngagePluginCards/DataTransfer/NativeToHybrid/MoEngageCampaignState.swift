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
        var data: [String : Any] = [
            HybridKeys.showCountTotal: self.showCountTotal,
            HybridKeys.isClicked: self.isClicked,
            HybridKeys.showCountCurrentDevice: self.showCountCurrentDevice,
        ]

        if let firstSeenTime = self.firstSeenTime {
            data[HybridKeys.firstSeenTime] = MoEngagePluginCardsUtil.convertDateToEpoch(firstSeenTime)
        }

        if let firstDeliveredTime = self.firstDeliveredTime {
            data[HybridKeys.firstDeliveredTime] = MoEngagePluginCardsUtil.convertDateToEpoch(firstDeliveredTime)
        }

        return data
    }
}
