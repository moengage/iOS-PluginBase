//
//  MoEngageCardsData.swift
//  MoEngagePluginBase
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardsData: HybridEncodable {
    enum HybridKeys {
        static let showAllTab = "shouldShowAllTab"
        static let cardCategories = "categories"
        static let cards = "cards"
    }

    func encodeForHybrid() -> [String: Any?] {
        return [
            HybridKeys.showAllTab: self.showAllTab,
            HybridKeys.cardCategories: self.cardCategories,
            HybridKeys.cards: self.cards.encodeForHybrid()
        ]
    }
}
