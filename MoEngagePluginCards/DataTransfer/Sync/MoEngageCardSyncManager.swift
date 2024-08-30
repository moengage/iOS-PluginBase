//
//  MoEngageCardSyncManager.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 20/06/23.
//

import MoEngageCore
import MoEngageCards

protocol MoEngageCardSyncManagerProtocol: MoEngageHybridSDKCardsDelegate {
    func setSyncListener()
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
    private var isSyncListenerSet: Bool

    init(
        queue: MoEngageCardSyncManagerSynchronizer = MoEngageCoreHandler.globalQueue,
        dataManager: MoEngageCardSyncDataManagerProtocol = MoEngageCardSyncDataManager(),
        isSyncListenerSet: Bool = false
    ) {
        self.queue = queue
        self.dataManager = dataManager
        self.isSyncListenerSet = isSyncListenerSet
    }

    func setSyncListener() {
        queue.async {
            self.isSyncListenerSet = true
            self.flushSyncEvents()
        }
    }

    func attachDelegate(_ delegate: MoEngageCardSyncDelegate) {
        queue.async {
            self.delegate = delegate
            self.flushSyncEvents()
        }
    }

    func flushSyncEvents() {
        for item in self.dataManager.dequeueSyncUpdateItems() {
            self.sendUpdate(
                forEventType: item.eventType,
                andAppID: item.appId,
                withNewData: item.data
            )
        }
    }

    func detachDelegate() {
        queue.async {
            self.delegate = nil
        }
    }

    func didSyncCards(
        forEvent event: MoEngageHybridCardsSyncType,
        recievedUpdate data: MoEngageCardSyncCompleteData
    ) {
        switch event {
        case .appOpen:
            self.sendUpdate(
                forEventType: .appOpen,
                andAppID: data.accountMeta.appID,
                withNewData: data
            )
            let dataForHybrid = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: data.accountMeta.appID,
                containingData: MoEngageCardSyncCompleteMetaData(
                    type: .appOpen,
                    data: data
                ).encodeForHybrid()
            )
            MoEngagePluginCardsLogger.debug(
                "Recieved app open sync callback \(dataForHybrid) in pluginbase",
                forData: dataForHybrid
            )
        case .immediateSync:
            self.sendUpdate(
                forEventType: .immediate,
                andAppID: data.accountMeta.appID,
                withNewData: data
            )
        default:
            break
        }
    }

    func sendUpdate(
        forEventType eventType: MoEngageCardsSyncEventType,
        andAppID appId: String,
        withNewData data: MoEngageCardSyncCompleteData?
    ) {
        queue.async {
            let metadata = MoEngageCardSyncCompleteMetaData(type: eventType, data: data)
            if let delegate = self.delegate,
               eventType != .appOpen || eventType != .immediate || self.isSyncListenerSet {
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
