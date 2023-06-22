//
//  MoEngageCardSyncTest.swift
//  MoEngagePluginCards-Unit-UnitTests
//
//  Created by Soumya Mahunt on 22/06/23.
//

import XCTest
import MoEngageCards
@testable import MoEngagePluginCards

final class MoEngageCardSyncTest: XCTestCase {

    func testCardSyncQueueCallbackOnAttach() throws {
        let syncManager = MoEngageCardSyncManager(queue: DispatchQueue.main)
        syncManager.sendUpdate(forEventType: .appOpen, andAppID: "", withNewData: nil)

        let exp = XCTestExpectation(description: "Sync delegate called once")
        let mockDelegate = MockSyncDelegate { type, data, count in
            XCTAssertEqual(type, .appOpen)
            let data: [String: Any?] = try! MoEngagePluginCardsUtil.getData(fromHybridPayload: data)
            switch data[MoEngageCardSyncCompleteMetaData.HybridKeys.syncCompleteData] {
            case .none:
                break
            case .some(let value):
                XCTAssertNil(value)
            }
            exp.fulfill()
        }
        syncManager.attachDelegate(mockDelegate)
        wait(for: [exp], timeout: 5)
    }

    func testCardSyncQueueCallbackAfterAttach() throws {
        let syncManager = MoEngageCardSyncManager(queue: DispatchQueue.main)
        let exp = XCTestExpectation(description: "Sync delegate called once")
        let mockDelegate = MockSyncDelegate { type, data, count in
            XCTAssertEqual(type, .inboxOpen)
            let data: [String: Any?] = try! MoEngagePluginCardsUtil.getData(fromHybridPayload: data)
            switch data[MoEngageCardSyncCompleteMetaData.HybridKeys.syncCompleteData] {
            case .none:
                break
            case .some(let value):
                XCTAssertNil(value)
            }
            exp.fulfill()
        }

        syncManager.attachDelegate(mockDelegate)
        syncManager.sendUpdate(forEventType: .inboxOpen, andAppID: "", withNewData: nil)
        wait(for: [exp], timeout: 5)
    }

    func testCardSyncQueueCallbackAfterDetachAndAttach() throws {
        let syncManager = MoEngageCardSyncManager(queue: DispatchQueue.main)
        let exp = XCTestExpectation(description: "Sync delegate called once")
        let mockDelegate = MockSyncDelegate { type, data, count in
            XCTAssertEqual(type, .inboxOpen)
            let data: [String: Any?] = try! MoEngagePluginCardsUtil.getData(fromHybridPayload: data)
            switch data[MoEngageCardSyncCompleteMetaData.HybridKeys.syncCompleteData] {
            case .none:
                break
            case .some(let value):
                XCTAssertNil(value)
            }
            exp.fulfill()
        }

        syncManager.attachDelegate(mockDelegate)
        syncManager.detachDelegate()
        syncManager.attachDelegate(mockDelegate)
        syncManager.sendUpdate(forEventType: .inboxOpen, andAppID: "", withNewData: nil)
        wait(for: [exp], timeout: 5)
    }
}

class MockSyncDelegate: MoEngageCardSyncDelegate {
    let assertion: (MoEngageCardsSyncEventType, [String : Any], UInt) -> Void
    var invocationCount: UInt = 0

    init(assertion: @escaping (MoEngageCardsSyncEventType, [String : Any], UInt) -> Void) {
        self.assertion = assertion
    }
    
    func syncComplete(
        forEventType eventType: MoEngageCardsSyncEventType,
        withData data: [String : Any]
    ) {
        invocationCount += 1
        self.assertion(eventType, data, invocationCount)
    }
}
