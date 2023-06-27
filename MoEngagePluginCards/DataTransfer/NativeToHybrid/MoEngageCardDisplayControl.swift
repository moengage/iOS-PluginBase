//
//  MoEngageCardDisplayControl.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardDisplayControl: HybridEncodable {
    enum HybridKeys {
        static let isPinned = "is_pin"
        static let maxTimesToShow = "max_times_to_show"
        static let expiryDate = "expire_at"
        static let expiryAfterSeenDuration = "expire_after_seen"
        static let expiryAfterDeliveredDuration = "expire_after_delivered"
        static let showTime = "show_time"
    }

    func encodeForHybrid() -> [String: Any?] {
        var data: [String : Any?] = [
            HybridKeys.isPinned: self.isPinned,
            HybridKeys.maxTimesToShow: self.maxTimesToShow,
            HybridKeys.showTime: self.showTime?.encodeForHybrid(),
        ]

        if let expiryDate = self.expiryDate {
            data[HybridKeys.expiryDate] = MoEngagePluginCardsUtil.convertDateToEpoch(expiryDate)
        }

        if let expiryAfterSeenDuration = self.expiryAfterSeenDuration {
            data[HybridKeys.expiryAfterSeenDuration] = expiryAfterSeenDuration.rounded(.down)
        }

        if let expiryAfterDeliveredDuration = self.expiryAfterDeliveredDuration {
            data[HybridKeys.expiryAfterDeliveredDuration] = expiryAfterDeliveredDuration.rounded(.down)
        }
        return data
    }
}
