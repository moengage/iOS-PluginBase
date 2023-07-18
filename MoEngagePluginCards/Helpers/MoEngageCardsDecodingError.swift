//
//  MoEngageCardsDecodingError.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import Foundation

struct MoEngageCardsDecodingError: Error, CustomStringConvertible {
    let key: String
    let data: Any
    let function: String

    init(key: String, data: Any, function: String = #function) {
        self.key = key
        self.data = data
        self.function = function
    }

    var description: String {
        "Failed to decode \(key) in data: \(data) at \(function)"
    }
}
