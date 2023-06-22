//
//  MoEngageCardCampaign.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardCampaign: HybridEncodable {
    enum HybridKeys {
        static let cardId = "card_id"
        static let category = "category"
        static let templateData = "template_data"
        static let nestedData = "meta_data"
        static let createdDate = "created_at"
        static let updatedDate = "updated_at"
        static let metaData = "metaData"
        static let displayControl = "display_controls"
        static let cardState = "campaignState"
        static let campaignPayload = "campaignPayload"
    }

    func encodeForHybrid() -> [String: Any?] {
        return [
            HybridKeys.cardId: self.cardID,
            HybridKeys.category: self.category,
            HybridKeys.templateData: self.templateData?.encodeForHybrid(),
            HybridKeys.nestedData: [
                HybridKeys.createdDate: self.createdDate?.timeIntervalSince1970,
                HybridKeys.updatedDate: self.updatedDate.timeIntervalSince1970,
                HybridKeys.displayControl: self.displayControl?.encodeForHybrid(),
                HybridKeys.cardState: self.cardState.encodeForHybrid(),
                HybridKeys.metaData: self.metaData,
                HybridKeys.campaignPayload: MoEngageHybridSDKCards.convertCardCampaignToJsonData(self)
            ] as [String : Any?]
        ]
    }
}
