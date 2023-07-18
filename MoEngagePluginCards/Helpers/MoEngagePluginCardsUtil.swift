//
//  MoEngagePluginCardsUtil.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 19/06/23.
//

import MoEngagePluginBase
import MoEngageCore
import MoEngageCards

enum MoEngagePluginCardsUtil {

    static func buildHybridPayload(
        forIdentifier identifier: String,
        containingData data: Any
    ) -> [String: Any] {
        let accountMeta = MoEngagePluginUtils.createAccountPayload(identifier: identifier)
        return [
            MoEngagePluginConstants.General.accountMeta: accountMeta,
            MoEngagePluginConstants.General.data: data
        ]
    }

    static func getData<T>(
        fromHybridPayload data: [String: Any],
        at function: String = #function
    ) throws -> T {
        guard
            let result = data[MoEngagePluginConstants.General.data] as? T
        else {
            throw MoEngageCardsDecodingError(
                key: MoEngagePluginConstants.General.data,
                data: data,
                function: function
            )
        }
        return result
    }

    static func getNestedData<T>(
        fromHybridPayload data: [String: Any],
        forKey key: String,
        at function: String = #function
    ) throws -> T {
        let parent: [String: Any] = try Self.getData(fromHybridPayload: data, at: function)
        guard
            let result = parent[key] as? T
        else {
            throw MoEngageCardsDecodingError(
                key: key,
                data: parent,
                function: function
            )
        }
        return result
    }

    static func convertRGBColorToHex(_ color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }

    static func convertDateToEpoch(_ date: Date) -> Double {
        return date.timeIntervalSince1970.rounded(.down)
    }
}
