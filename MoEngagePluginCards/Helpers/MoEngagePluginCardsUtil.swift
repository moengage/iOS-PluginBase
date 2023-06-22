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
        containingData data: Any?
    ) -> [String: Any] {
        let accountMeta = MoEngagePluginUtils.createAccountPayload(identifier: identifier)
        return [
            MoEngagePluginConstants.General.accountMeta: accountMeta,
            MoEngagePluginConstants.General.data: data as Any
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
}
