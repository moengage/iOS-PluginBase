//
//  MoEngageCardWidget.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardWidget: HybridEncodable {
    enum HybridKeys {
        static let id = "id"
        static let type = "type"
        static let content = "content"
        static let style = "style"
        static let actions = "actions"
        static let accessibility = "accessibility"
    }

    func encodeForHybrid() -> [String : Any?] {
        return [
            HybridKeys.id: self.id,
            HybridKeys.type: self.type.rawValue,
            HybridKeys.content: self.content,
            HybridKeys.style: self.style?.encodeForHybrid(),
            HybridKeys.actions: self.actions.encodeForHybrid(),
            HybridKeys.accessibility: self.accessibilityData?.encodeForHybrid()
        ]
    }
}
