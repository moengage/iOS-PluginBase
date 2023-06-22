//
//  MoEngageCardSyncCompleteMetaData.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCards

@objc public enum MoEngageCardsSyncEventType: Int, CustomStringConvertible {
    case pullToRefresh
    case inboxOpen
    case appOpen

    public var description: String {
        switch self {
        case .pullToRefresh:
            return "PULL_TO_REFRESH"
        case .inboxOpen:
            return "INBOX_OPEN"
        case .appOpen:
            return "APP_OPEN"
        }
    }
}

struct MoEngageCardSyncCompleteMetaData: HybridEncodable {
    let type: MoEngageCardsSyncEventType?
    let data: MoEngageCardSyncCompleteData?

    init(
        type: MoEngageCardsSyncEventType? = nil,
        data: MoEngageCardSyncCompleteData? = nil
    ) {
        self.type = type
        self.data = data
    }

    enum HybridKeys {
        static let syncCompleteData = "syncCompleteData"
        static let hasUpdates = "hasUpdates"
        static let type = "syncType"
    }

    func encodeForHybrid() -> [String : Any?] {
        self.encodeForHybrid(forceUpdate: false)
    }

    func encodeForHybrid(forceUpdate: Bool) -> [String : Any?] {
        let syncCompleteData: [String: Any?]?
        if let type = self.type, let data = self.data {
            syncCompleteData = [
                HybridKeys.type: type.description,
                HybridKeys.hasUpdates: forceUpdate || data.hasUpdates,
            ]
        } else {
            syncCompleteData = nil
        }
        return [
            HybridKeys.syncCompleteData: syncCompleteData
        ]
    }
}
