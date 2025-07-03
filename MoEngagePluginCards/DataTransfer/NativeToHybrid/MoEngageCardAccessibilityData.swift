//
//  MoEngageCardWidget.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

extension MoEngageCardAccessibilityData: HybridEncodable {
    enum HybridKeys {
        static let text = "text"
        static let hint = "hint"
    }
    
    func encodeForHybrid() -> [String : Any?] {
        return [
            HybridKeys.text: self.label,
            HybridKeys.hint: self.hint]
    }
}
