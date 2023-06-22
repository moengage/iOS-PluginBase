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
        return [
            HybridKeys.isPinned: self.isPinned,
            HybridKeys.maxTimesToShow: self.maxTimesToShow,
            HybridKeys.expiryDate: self.expiryDate?.timeIntervalSince1970,
            HybridKeys.expiryAfterSeenDuration: self.expiryAfterSeenDuration,
            HybridKeys.expiryAfterDeliveredDuration: self.expiryAfterDeliveredDuration,
            HybridKeys.showTime: self.showTime,
        ]
    }
}
