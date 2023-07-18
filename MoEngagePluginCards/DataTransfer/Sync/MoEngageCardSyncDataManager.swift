//
//  MoEngageCardSyncDataManager.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 22/06/23.
//

import MoEngageCards

protocol MoEngageCardSyncDataManagerProtocol {
    func dequeueSyncUpdateItems() -> [MoEngageCardSyncDataManager.QueueItem]
    func queueCardSyncUpdate(
        forEventType eventType: MoEngageCardsSyncEventType,
        andAppID appId: String,
        data: MoEngageCardSyncCompleteData?
    )
}

final class MoEngageCardSyncDataManager: MoEngageCardSyncDataManagerProtocol {
    struct QueueItem {
        let eventType: MoEngageCardsSyncEventType
        let appId: String
        let data: MoEngageCardSyncCompleteData?
    }

    private var items: [QueueItem] = []

    func queueCardSyncUpdate(
        forEventType eventType: MoEngageCardsSyncEventType,
        andAppID appId: String,
        data: MoEngageCardSyncCompleteData?
    ) {
        items.append(.init(eventType: eventType, appId: appId, data: data))
    }

    func dequeueSyncUpdateItems() -> [QueueItem] {
        defer { items = [] }
        return items
    }
}
