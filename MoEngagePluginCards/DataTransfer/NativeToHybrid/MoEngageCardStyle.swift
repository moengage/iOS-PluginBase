//
//  MoEngageCardStyle.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardStyle: HybridEncodable {
    enum HybridKeys {
        static let bgColor = "bgColor"
    }

    func encodeForHybrid() -> [String : Any?] {
        return [
            HybridKeys.bgColor: self.bgColor?.convertRGBToHex(),
        ]
    }
}
