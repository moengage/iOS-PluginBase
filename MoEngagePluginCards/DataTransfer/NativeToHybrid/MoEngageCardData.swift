//
//  MoEngageCardData.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 17/07/23.
//

import MoEngageCards

extension MoEngageCardData: HybridEncodable {
    enum HybridKeys {
        static let cards = MoEngagePluginCardsContants.cards
    }

    func encodeForHybrid() -> [String : Any?] {
        return [
            HybridKeys.cards: cards.encodeForHybrid()
        ]
    }
}
