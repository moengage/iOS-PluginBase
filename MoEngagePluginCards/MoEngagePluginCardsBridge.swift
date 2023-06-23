//
//  MoEngagePluginCardsBridge.swift
//  MoEngagePluginCards
//
//  Created by Soumya Mahunt on 19/06/23.
//

import MoEngagePluginBase
import MoEngageCore
import MoEngageCards

@objc public protocol MoEngageCardSyncDelegate {
    func syncComplete(forEventType eventType: MoEngageCardsSyncEventType, withData data: [String: Any])
}

@objc final public class MoEngagePluginCardsBridge: NSObject {
    @objc public static let sharedInstance = MoEngagePluginCardsBridge()

    private let handler: MoEngagePluginCardsBridgeHandler
    private let syncManager: MoEngageCardSyncManagerProtocol

    private init(
        handler: MoEngagePluginCardsBridgeHandler = MoEngageSDKCards.sharedInstance,
        syncManager: MoEngageCardSyncManagerProtocol = MoEngageCardSyncManager()
    ) {
        self.handler = handler
        self.syncManager = syncManager
    }

    private func logAppIdentifierFetchFailed(
        for payload: [String: Any],
        at function: String = #function
    ) {
        MoEngageLogger.error(
            "Could't find app identifier data for payload: \(payload) at \(function)"
        )
    }

    @objc public func setSyncEventListnerDelegate(_ delegate: MoEngageCardSyncDelegate) {
        syncManager.attachDelegate(delegate)
    }

    @objc public func onFrameworkDetached() {
        syncManager.detachDelegate()
    }

    @objc public func initialize(_ accountData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
    }

    @objc public func refreshCards(_ accountData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }

        MoEngageSDKCards.sharedInstance.refreshCards(forAppID: identifier) { data in
            self.syncManager.sendUpdate(
                forEventType: .pullToRefresh,
                andAppID: identifier,
                withNewData: data
            )
        }
    }

    @objc public func onCardsSectionLoaded(_ accountData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }

        MoEngageSDKCards.sharedInstance.onCardSectionLoaded(forAppID: identifier) { data in
            self.syncManager.sendUpdate(
                forEventType: .inboxOpen,
                andAppID: identifier,
                withNewData: data
            )
        }
    }

    @objc public func setAppOpenSyncListener(_ accountData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }

        MoEngageSDKCards.sharedInstance.onAppOpenSync(forAppID: identifier) { data in
            self.syncManager.sendUpdate(
                forEventType: .inboxOpen,
                andAppID: identifier,
                withNewData: data
            )
        }
    }

    @objc public func onCardsSectionUnLoaded(_ accountData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        self.handler.cardsViewControllerDismissed(forAppID: identifier)
    }

    @objc public func cardClicked(_ cardData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: cardData
            )
        else {
            logAppIdentifierFetchFailed(for: cardData)
            return
        }

        let cardClick: MoEngageCardClickData
        do {
            let clickData: [String: Any] = try MoEngagePluginCardsUtil.getData(fromHybridPayload: cardData)
            cardClick = try MoEngageCardClickData.decodeFromHybrid(clickData)
        } catch {
            MoEngageLogger.error("\(error)")
            return
        }

        if let widgetId = cardClick.widgetId {
            self.handler.cardClicked(
                cardClick.card, withWidgetID: widgetId,
                forAppID: identifier
            )
        } else {
            self.handler.cardClicked(cardClick.card, forAppID: identifier)
        }
    }

    @objc public func cardDelivered(_ accountData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        self.handler.cardDelivered(forAppID: identifier)
    }

    @objc public func cardShown(_ cardData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: cardData
            )
        else {
            logAppIdentifierFetchFailed(for: cardData)
            return
        }

        let card: MoEngageCardCampaign
        do {
            let showData: [String: Any] = try MoEngagePluginCardsUtil.getData(fromHybridPayload: cardData)
            card = try MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: showData)
        } catch {
            MoEngageLogger.error("\(error)")
            return
        }
        self.handler.cardShown(card, forAppID: identifier)
    }

    @objc public func deleteCards(_ cardsData: [String: Any]) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: cardsData
            )
        else {
            logAppIdentifierFetchFailed(for: cardsData)
            return
        }

        let cards: [MoEngageCardCampaign]
        do {
            let cardsData: [[String: Any]] = try MoEngagePluginCardsUtil.getData(fromHybridPayload: cardsData)
            cards = cardsData.decodeFromHybrid()
        } catch {
            MoEngageLogger.error("\(error)")
            return
        }
        self.handler.deleteCards(cards, forAppID: identifier) { _, _ in }
    }

    @objc public func getCardsInfo(
        _ accountData: [String: Any],
        completionHandler: @escaping ([String: Any]) -> Void
    ) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        self.handler.getCardsData(
            forAppID: identifier
        ) { cardsData, accountMeta in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: cardsData?.encodeForHybrid() as Any
            )
            completionHandler(result)
        }
    }

    @objc public func getCardsCategories(
        _ accountData: [String: Any],
        completionHandler: @escaping ([String: Any]) -> Void
    ) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        self.handler.getCardsCategories(forAppID: identifier) { categories, accountMeta in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.categories: categories
                ]
            )
            completionHandler(result)
        }
    }

    @objc public func getCardsForCategory(
        _ categoryData: [String: Any],
        completionHandler: @escaping ([String: Any]) -> Void
    ) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: categoryData
            )
        else {
            logAppIdentifierFetchFailed(for: categoryData)
            return
        }

        let cardsCategory: MoEngageCardsCategoryData
        do {
            let categoryData: [String: Any] = try MoEngagePluginCardsUtil.getData(fromHybridPayload: categoryData)
            cardsCategory = try MoEngageCardsCategoryData.decodeFromHybrid(categoryData)
        } catch {
            MoEngageLogger.error("\(error)")
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: nil
            )
            completionHandler(result)
            return
        }

        self.handler.getCards(
            forCategory: cardsCategory.category,
            forAppID: identifier
        ) { cards, accountMeta in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.category: cardsCategory.category,
                    MoEngagePluginCardsContants.cards: cards.encodeForHybrid()
                ]
            )
            completionHandler(result)
        }
    }

    @objc public func isAllCategoryEnabled(
        _ accountData: [String: Any],
        completionHandler: @escaping ([String: Any]) -> Void
    ) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        self.handler.isAllCategoryEnabled(forAppID: identifier) { isEnabled in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.isAllCategoryEnabled: isEnabled
                ]
            )
            completionHandler(result)
        }
    }

    @objc public func getNewCardsCount(
        _ accountData: [String: Any],
        completionHandler: @escaping ([String: Any]) -> Void
    ) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        self.handler.getNewCardsCount(forAppID: identifier) { count, accountMeta  in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.newCardsCount: count
                ]
            )
            completionHandler(result)
        }
    }

    @objc public func getUnClickedCardsCount(
        _ accountData: [String: Any],
        completionHandler: @escaping ([String: Any]) -> Void
    ) {
        guard
            let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        self.handler.getUnclickedCardsCount(forAppID: identifier) { count, accountMeta  in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.unClickedCardsCount: count
                ]
            )
            completionHandler(result)
        }
    }
}

protocol MoEngagePluginCardsBridgeHandler {
    func onAppOpenSync(
        forAppID appID: String?,
        withCompletion completionBlock: ((_ data: MoEngageCardSyncCompleteData?) -> Void)?
    )

    func onCardSectionLoaded(
        forAppID appID: String?,
        withCompletion completionBlock: ((_ data: MoEngageCardSyncCompleteData?) -> Void)?
    )

    func refreshCards(
        forAppID appID: String?,
        withCompletion completionBlock: ((_ data: MoEngageCardSyncCompleteData?) -> Void)?
    )

    func getCardsData(
        forAppID appID: String?,
        withCompletionBlock completionBlock: @escaping ((_ cardsData: MoEngageCardsData?, _ accountMeta: MoEngageAccountMeta?) -> Void)
    )

    func getCardsCategories(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((_ categories: [String], _ accountMeta: MoEngageAccountMeta?) -> ())
    )

    func getCards(
        forCategory category: String,
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((_ cards: [MoEngageCardCampaign], _ accountMeta: MoEngageAccountMeta?) -> Void)
    )

    func isAllCategoryEnabled(
        forAppID appID: String?,
        withCompletionBlock completionBlock: @escaping ((Bool) -> Void)
    )

    func cardShown(_ card: MoEngageCardCampaign, forAppID appID: String?)

    func cardClicked(_ card: MoEngageCardCampaign, forAppID appID: String?)
    func cardClicked(_ card: MoEngageCardCampaign, withWidgetID widgetID: Int, forAppID appID: String?)

    func cardDelivered(forAppID appID: String?)

    func deleteCards(
        _ cardsArr: [MoEngageCardCampaign],
        forAppID appID: String?,
        andCompletionBlock completionBlock:
        @escaping ((_ isDeleted: Bool, _ accountMeta: MoEngageAccountMeta?) -> ())
    )

    func cardsViewControllerDismissed(forAppID appID: String?)

    func getNewCardsCount(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((_ count: Int, _ accountMeta: MoEngageAccountMeta?) -> Void)
    )


    func getUnclickedCardsCount(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((_ count: Int, _ accountMeta: MoEngageAccountMeta?) -> Void)
    )

    func getClickedCardsCount(
        forAppID appID: String?,
        withCompletionBlock completionBlock:
        @escaping ((_ count: Int, _ accountMeta: MoEngageAccountMeta?) -> Void)
    )
}

extension MoEngageSDKCards: MoEngagePluginCardsBridgeHandler {}
