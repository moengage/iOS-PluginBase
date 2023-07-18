//
//  MoEngageCardsCategoryData.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 21/06/23.
//

import MoEngageCards

struct MoEngageCardsCategoryData {
    enum HybridKeys {
        static let category = "category"
    }

    let category: String

    init(category: String) {
        self.category = category
    }

    static func decodeFromHybrid(_ data: [String: Any]) throws -> Self {
        guard let category = data[HybridKeys.category] as? String else {
            throw MoEngageCardsDecodingError(key: HybridKeys.category, data: data)
        }
        return self.init(category: category)
    }
}
