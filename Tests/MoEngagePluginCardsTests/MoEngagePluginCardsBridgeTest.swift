//
//  MoEngagePluginCardsBridgeTest.swift
//  MoEngagePluginCards-Unit-UnitTests
//
//  Created by Soumya Mahunt on 23/06/23.
//

import XCTest
import MoEngageCards
import MoEngagePluginBase
@testable import MoEngagePluginCards

final class MoEngagePluginCardsBridgeTest: XCTestCase {

    var mockBaseData: [String: Any] {
        return [
            MoEngagePluginConstants.General.accountMeta: [
                "appId": "some_id"
            ]
        ]
    }

    static func mockHybridCardCampaign(
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> [String: Any] {
        guard
            let data = try JSONSerialization.jsonObject(
                with: MoEngageCardCampaignTest.json
            ) as? [String: Any]
        else {
            XCTFail("Invalid JSON input", file: file, line: line)
            return [:]
        }
        return data
    }

    func testRefreshCardsFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.refreshCards = { appId, completion in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.refreshCards([:])
        wait(for: [exp], timeout: 5)
    }

    func testRefreshCardsSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.refreshCards = { appId, completion in
            XCTAssertEqual(appId, "some_id")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.refreshCards(self.mockBaseData)
        wait(for: [exp], timeout: 5)
    }

    func testCardsSectionLoadedFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.cardSectionLoaded = { appId, completion in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.onCardsSectionLoaded([:])
        wait(for: [exp], timeout: 5)
    }

    func testCardsSectionLoadedSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.cardSectionLoaded = { appId, completion in
            XCTAssertEqual(appId, "some_id")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.onCardsSectionLoaded(self.mockBaseData)
        wait(for: [exp], timeout: 5)
    }

    func testAppOpenSyncListenerSetFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.appOpenSync = { appId, completion in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.setSyncListener([:])
        wait(for: [exp], timeout: 5)
    }

    func testAppOpenSyncListenerSetSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Inavalid native SDK method invocation")
        exp.isInverted = true
        mockHandler.appOpenSync = { appId, completion in
            XCTAssertEqual(appId, "some_id")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.setSyncListener(self.mockBaseData)
        wait(for: [exp], timeout: 5)
    }

    func testCardsSectionUnLoadedFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.cardsViewControllerDismissed = { appId in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.onCardsSectionUnLoaded([:])
        wait(for: [exp], timeout: 5)
    }

    func testCardsSectionUnLoadedSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.cardsViewControllerDismissed = { appId in
            XCTAssertEqual(appId, "some_id")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.onCardsSectionUnLoaded(self.mockBaseData)
        wait(for: [exp], timeout: 5)
    }

    func testCardClickedFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.cardClicked = { card, appId in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.cardClicked([:])
        wait(for: [exp], timeout: 5)
    }

    func testCardClickedSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.cardClicked = { card, appId in
            XCTAssertEqual(appId, "some_id")
            XCTAssertNotNil(card)
            XCTAssertTrue(card.shouldShow)
            XCTAssertEqual(card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
            XCTAssertEqual(card.category, "Announcements")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        var data = self.mockBaseData
        data[MoEngagePluginConstants.General.data] = [
            MoEngageCardClickData.HybridKeys.card: try Self.mockHybridCardCampaign()
        ]
        bridge.cardClicked(data)
        wait(for: [exp], timeout: 5)
    }

    func testCardClickedSuccessWithWidgetId() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.cardWidgetClicked = { card, widgetId, appId in
            XCTAssertEqual(appId, "some_id")
            XCTAssertNotNil(card)
            XCTAssertTrue(card.shouldShow)
            XCTAssertEqual(card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
            XCTAssertEqual(card.category, "Announcements")
            XCTAssertNotNil(widgetId)
            XCTAssertEqual(widgetId, 5)
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        var data = self.mockBaseData
        data[MoEngagePluginConstants.General.data] = [
            MoEngageCardClickData.HybridKeys.widgetId: 5,
            MoEngageCardClickData.HybridKeys.card: try Self.mockHybridCardCampaign()
        ] as [String : Any]
        bridge.cardClicked(data)
        wait(for: [exp], timeout: 5)
    }

    func testCardDeliveredFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.cardDelivered = { appId in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.cardDelivered([:])
        wait(for: [exp], timeout: 5)
    }

    func testCardDeliveredSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.cardDelivered = { appId in
            XCTAssertEqual(appId, "some_id")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.cardDelivered(self.mockBaseData)
        wait(for: [exp], timeout: 5)
    }

    func testCardShownFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.cardShown = { card, appId in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.cardShown([:])
        wait(for: [exp], timeout: 5)
    }

    func testCardShownSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.cardShown = { card, appId in
            XCTAssertEqual(appId, "some_id")
            XCTAssertNotNil(card)
            XCTAssertTrue(card.shouldShow)
            XCTAssertEqual(card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
            XCTAssertEqual(card.category, "Announcements")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        var data = self.mockBaseData
        data[MoEngagePluginConstants.General.data] = [
            MoEngagePluginCardsContants.card: try Self.mockHybridCardCampaign()
        ]
        bridge.cardShown(data)
        wait(for: [exp], timeout: 5)
    }

    func testDeleteCardsFailWithInvalidAccountData() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Invoked with invalid account data")
        exp.isInverted = true
        mockHandler.deleteCards = { cards, appId, completion in
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        bridge.deleteCards([:])
        wait(for: [exp], timeout: 5)
    }

    func testDeleteCardsSuccess() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.deleteCards = { cards, appId, completion in
            XCTAssertEqual(appId, "some_id")
            XCTAssertNotNil(cards.first)
            guard let card = cards.first else { return }
            XCTAssertNotNil(card)
            XCTAssertTrue(card.shouldShow)
            XCTAssertEqual(card.cardID, "000000000001686897366450_F_T_CA_AB_0_P_0_L_0_ios")
            XCTAssertEqual(card.category, "Announcements")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        var data = self.mockBaseData
        data[MoEngagePluginConstants.General.data] = [
            MoEngagePluginCardsContants.cards: [try Self.mockHybridCardCampaign()]
        ]
        bridge.deleteCards(data)
        wait(for: [exp], timeout: 5)
    }

    func testFetchCards() throws {
        let mockHandler = MockMoEngagePluginCardsBridgeHandler()
        let exp = XCTestExpectation(description: "Native SDK method invoked")
        mockHandler.fetchCards = { appId, completion in
            XCTAssertEqual(appId, "some_id")
            exp.fulfill()
        }

        let bridge = MoEngagePluginCardsBridge(handler: mockHandler)
        var data = self.mockBaseData
        data[MoEngagePluginConstants.General.data] = [
            MoEngagePluginCardsContants.cards: [try Self.mockHybridCardCampaign()]
        ]
        bridge.fetchCards(self.mockBaseData) { payload in }
        wait(for: [exp], timeout: 5)
    }
}

class MockMoEngagePluginCardsBridgeHandler: MoEngagePluginCardsBridgeHandler {
    var appOpenSync: ((String?, ((MoEngageCardSyncCompleteData?) -> Void)?) -> Void)?
    var cardSectionLoaded: ((String?, ((MoEngageCardSyncCompleteData?) -> Void)?) -> Void)?
    var refreshCards: ((String?, ((MoEngageCardSyncCompleteData?) -> Void)?) -> Void)?

    var fetchCards: ((String?, ((MoEngageCardData?) -> Void)?) -> Void)?

    var getCardsCategories: ((String?, (([String], MoEngageAccountMeta?) -> Void)) -> Void)?

    var getCardsData: ((String?, ((MoEngageCardsData?, MoEngageAccountMeta?) -> Void)) -> Void)?

    var getCards: ((String, String?, (([MoEngageCardCampaign], MoEngageAccountMeta?) -> Void)) -> Void)?

    var isAllCategoryEnabled: ((String?, ((Bool) -> Void)) -> Void)?

    var cardShown: ((MoEngageCardCampaign, String?) -> Void)?
    var cardClicked: ((MoEngageCardCampaign, String?) -> Void)?
    var cardWidgetClicked: ((MoEngageCardCampaign, Int, String?) -> Void)?
    var cardDelivered: ((String?) -> Void)?

    var cardsViewControllerDismissed: ((String?) -> Void)?

    var deleteCards: (([MoEngageCardCampaign], String?, ((Bool, MoEngageAccountMeta?) -> Void)) -> Void)?

    var getNewCardsCount: ((String?, ((Int, MoEngageAccountMeta?) -> Void)) -> Void)?
    var getUnclickedCardsCount: ((String?, ((Int, MoEngageAccountMeta?) -> Void)) -> Void)?
    var getClickedCardsCount: ((String?, ((Int, MoEngageAccountMeta?) -> Void)) -> Void)?

    func onAppOpenSync(
        forAppID appID: String?,
        withCompletion completionBlock: ((MoEngageCardSyncCompleteData?) -> Void)?
    ) {
        appOpenSync?(appID, completionBlock)
    }

    func onCardSectionLoaded(
        forAppID appID: String?,
        withCompletion completionBlock: ((MoEngageCardSyncCompleteData?) -> Void)?
    ) {
        cardSectionLoaded?(appID, completionBlock)
    }

    func refreshCards(
        forAppID appID: String?,
        withCompletion completionBlock: ((MoEngageCardSyncCompleteData?) -> Void)?
    ) {
        refreshCards?(appID, completionBlock)
    }

    func fetchCards(
        forAppID appID: String?,
        withCompletion completionBlock: ((MoEngageCardData?) -> Void)?
    ) {
        fetchCards?(appID, completionBlock)
    }

    func getCardsData(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((MoEngageCardsData?, MoEngageAccountMeta?) -> Void)
    ) {
        self.getCardsData?(appID, completionBlock)
    }

    func getCardsCategories(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping (([String], MoEngageAccountMeta?) -> ())
    ) {
        self.getCardsCategories?(appID, completionBlock)
    }

    func getCards(
        forCategory category: String,
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping (([MoEngageCardCampaign], MoEngageAccountMeta?) -> Void)
    ) {
        self.getCards?(category, appID, completionBlock)
    }

    func isAllCategoryEnabled(
        forAppID appID: String?,
        withCompletionBlock completionBlock: @escaping ((Bool) -> Void)
    ) {
        self.isAllCategoryEnabled?(appID, completionBlock)
    }

    func cardShown(_ card: MoEngageCardCampaign, forAppID appID: String?) {
        self.cardShown?(card, appID)
    }

    func cardClicked(_ card: MoEngageCardCampaign, forAppID appID: String?) {
        self.cardClicked?(card, appID)
    }

    func cardClicked(
        _ card: MoEngageCardCampaign,
        withWidgetID widgetID: Int,
        forAppID appID: String?
    ) {
        self.cardWidgetClicked?(card, widgetID, appID)
    }

    func cardDelivered(forAppID appID: String?) {
        self.cardDelivered?(appID)
    }

    func deleteCards(
        _ cardsArr: [MoEngageCardCampaign],
        forAppID appID: String?,
        andCompletionBlock completionBlock: @escaping ((Bool, MoEngageAccountMeta?) -> ())
    ) {
        self.deleteCards?(cardsArr, appID, completionBlock)
    }

    func cardsViewControllerDismissed(forAppID appID: String?) {
        cardsViewControllerDismissed?(appID)
    }

    func getNewCardsCount(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((Int, MoEngageAccountMeta?) -> Void)
    ) {
        self.getNewCardsCount?(appID, completionBlock)
    }

    func getUnclickedCardsCount(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((Int, MoEngageAccountMeta?) -> Void)
    ) {
        self.getUnclickedCardsCount?(appID, completionBlock)
    }

    func getClickedCardsCount(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((Int, MoEngageAccountMeta?) -> Void)
    ) {
        self.getClickedCardsCount?(appID, completionBlock)
    }
}
