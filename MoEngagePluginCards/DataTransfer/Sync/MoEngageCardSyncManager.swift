//
//  MoEngageCardSyncManager.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCore
import MoEngageCards

protocol MoEngageCardSyncManagerProtocol {
    func attachDelegate(_ delegate: MoEngageCardSyncDelegate)
    func detachDelegate()

    func sendUpdate(
        forEventType eventType: MoEngageCardsSyncEventType,
        andAppID appId: String,
        withNewData data: MoEngageCardSyncCompleteData?
    )
}

final class MoEngageCardSyncManager: MoEngageCardSyncManagerProtocol {
    private let queue: MoEngageCardSyncManagerSynchronizer
    private let dataManager: MoEngageCardSyncDataManagerProtocol
    private var delegate: MoEngageCardSyncDelegate?

    init(
        queue: MoEngageCardSyncManagerSynchronizer = MoEngageCoreHandler.globalQueue,
        dataManager: MoEngageCardSyncDataManagerProtocol = MoEngageCardSyncDataManager()
    ) {
        self.queue = queue
        self.dataManager = dataManager
    }

    func attachDelegate(_ delegate: MoEngageCardSyncDelegate) {
        queue.async {
            self.delegate = delegate
            for item in self.dataManager.dequeueSyncUpdateItems() {
                self.sendUpdate(
                    forEventType: item.eventType,
                    andAppID: item.appId,
                    withNewData: item.data
                )
            }
        }
    }

    func detachDelegate() {
        queue.async {
            self.delegate = nil
        }
    }

    func sendUpdate(
        forEventType eventType: MoEngageCardsSyncEventType,
        andAppID appId: String,
        withNewData data: MoEngageCardSyncCompleteData?
    ) {
        queue.async {
            let metadata = MoEngageCardSyncCompleteMetaData(type: eventType, data: data)
            if let delegate = self.delegate {
                let dataForHybrid = MoEngagePluginCardsUtil.buildHybridPayload(
                    forIdentifier: appId,
                    containingData: metadata.encodeForHybrid()
                )
                DispatchQueue.main.async {
                    delegate.syncComplete(
                        forEventType: eventType,
                        withData: dataForHybrid
                    )
                }
            } else {
                self.dataManager.queueCardSyncUpdate(
                    forEventType: eventType,
                    andAppID: appId,
                    data: data
                )
            }
        }
    }
}

protocol MoEngageCardSyncManagerSynchronizer {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: MoEngageCardSyncManagerSynchronizer {
    func async(execute work: @escaping @convention(block) () -> Void) {
        self.async(group: nil, execute: work)
    }
}
