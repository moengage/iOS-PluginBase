//
//  MoEngageCardTemplateData.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardTemplateData: HybridEncodable {
    enum HybridKeys {
        static let type = "type"
        static let containers = "containers"
    }

    func encodeForHybrid() -> [String: Any?] {
        return [
            HybridKeys.type: self.type.rawValue,
            HybridKeys.containers: self.containers.encodeForHybrid(),
        ]
    }
}
