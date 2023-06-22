//
//  MoEngageCardContainer.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardContainer: HybridEncodable {
    enum HybridKeys {
        static let id = "id"
        static let type = "type"
        static let style = "style"
        static let actions = "actions"
        static let widgets = "widgets"
    }

    func encodeForHybrid() -> [String : Any?] {
        return [
            HybridKeys.id: self.id,
            HybridKeys.type: self.type.rawValue,
            HybridKeys.style: self.style?.encodeForHybrid(),
            HybridKeys.actions: self.actions.encodeForHybrid(),
            HybridKeys.widgets: self.widgets.encodeForHybrid(),
        ]
    }
}
