//
//  HybridEncodable.swift
//  MoEngagePluginBase
//
//  Created by Soumya Mahunt on 20/06/23.
//

import Foundation

protocol HybridEncodable {
    func encodeForHybrid() -> [String: Any?]
}

extension Array where Element: HybridEncodable {
    func encodeForHybrid() -> [[String: Any?]] {
        var data: [[String: Any?]] = []
        data.reserveCapacity(self.count)
        for element in self {
            data.append(element.encodeForHybrid())
        }
        return data
    }
}
