//
//  MoEngageCardShowTime.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardShowTime: HybridEncodable {
    enum HybridKeys {
        static let startTime = "start_time"
        static let endTime = "end_time"
    }

    func encodeForHybrid() -> [String: Any?] {
        return [
            HybridKeys.startTime: self.startTime,
            HybridKeys.endTime: self.endTime,
        ]
    }
}
