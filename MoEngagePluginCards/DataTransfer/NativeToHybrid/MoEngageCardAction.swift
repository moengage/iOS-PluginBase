//
//  MoEngageCardAction.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardAction: HybridEncodable {
    enum HybridKeys {
        static let name = "name"
        static let type = "type"
        static let value = "value"
        static let kvPairs = "kvPairs"
    }

    func encodeForHybrid() -> [String : Any?] {
        return [
            HybridKeys.name: self.name,
            HybridKeys.type: self.type.rawValue,
            HybridKeys.value: self.value,
            HybridKeys.kvPairs: self.kvPairs,
        ]
    }
}
