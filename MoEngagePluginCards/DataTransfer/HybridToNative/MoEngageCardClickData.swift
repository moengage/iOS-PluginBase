//
//  MoEngageCardClickData.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 21/06/23.
//

import MoEngageCards

struct MoEngageCardClickData {
    enum HybridKeys {
        static let widgetId = "widgetId"
        static let card = "card"
    }

    let widgetId: Int?
    let card: MoEngageCardCampaign

    init(widgetId: Int?, card: MoEngageCardCampaign) {
        self.widgetId = widgetId
        self.card = card
    }

    static func decodeFromHybrid(_ data: [String: Any]) throws -> Self {
        guard let cardData = data[HybridKeys.card] as? [String: Any] else {
            throw MoEngageCardsDecodingError(key: HybridKeys.card, data: data)
        }

        let widgetId = data[HybridKeys.widgetId] as? Int
        return try self.init(
            widgetId: widgetId == -1 ? nil : widgetId,
            card: MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: cardData)
        )
    }
}
