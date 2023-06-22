//
//  MoEngageCardCampaign+Array.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 21/06/23.
//

import MoEngageCore
import MoEngageCards

extension Array where Element == [String: Any] {
    func decodeFromHybrid() -> [MoEngageCardCampaign] {
        var cards: [MoEngageCardCampaign] = []
        cards.reserveCapacity(self.count)
        for cardData in self {
            let card: MoEngageCardCampaign
            do {
                card = try MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: cardData)
            } catch {
                MoEngageLogger.error("\(error)")
                continue
            }
            cards.append(card)
        }
        return cards
    }
}
