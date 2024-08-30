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

    internal init(
        handler: MoEngagePluginCardsBridgeHandler = MoEngageSDKCards.sharedInstance,
        syncManager: MoEngageCardSyncManagerProtocol = MoEngageCardSyncManager()
    ) {
        self.handler = handler
        self.syncManager = syncManager
        MoEngageHybridSDKCards.hybridCardsDelegate = syncManager
    }

    private func logAppIdentifierFetchFailed(
        for payload: [String: Any],
        at function: String = #function
    ) {
        MoEngagePluginCardsLogger.error(
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
            let _ = MoEngagePluginUtils.fetchIdentifierFromPayload(
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

        MoEngagePluginCardsLogger.debug("Refresh Cards - ", forData: accountData)
        handler.refreshCards(forAppID: identifier) { data in
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

        
        MoEngagePluginCardsLogger.debug("On CardsSection Loaded - ", forData: accountData)

        handler.onCardSectionLoaded(forAppID: identifier) { data in
            self.syncManager.sendUpdate(
                forEventType: .inboxOpen,
                andAppID: identifier,
                withNewData: data
            )
        }
    }

    @objc public func setSyncListener(_ accountData: [String: Any]) {
        guard
            let _ = MoEngagePluginUtils.fetchIdentifierFromPayload(
                attribute: accountData
            )
        else {
            logAppIdentifierFetchFailed(for: accountData)
            return
        }
        
        MoEngagePluginCardsLogger.debug("AppOpen Sync Listener - ", forData: accountData)
        syncManager.setSyncListener()
    }

    @objc public func fetchCards(
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
        MoEngagePluginCardsLogger.debug("Fetch Cards - ", forData: accountData)
        handler.fetchCards(forAppID: identifier) { data in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: data?.encodeForHybrid() ?? [:]
            )
            MoEngagePluginCardsLogger.debug("Fetch Cards response - ", forData: result)
            completionHandler(result)
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
        MoEngagePluginCardsLogger.debug("Card Section Unloaded - ", forData: accountData)
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

        MoEngagePluginCardsLogger.debug("Card Clicked - ", forData: cardData)
        do {
            let clickData: [String: Any] = try MoEngagePluginCardsUtil.getData(fromHybridPayload: cardData)
            let cardClick = try MoEngageCardClickData.decodeFromHybrid(clickData)
            if let widgetId = cardClick.widgetId {
                self.handler.cardClicked(
                    cardClick.card, withWidgetID: widgetId,
                    forAppID: identifier
                )
            } else {
                self.handler.cardClicked(cardClick.card, forAppID: identifier)
            }
        } catch {
            MoEngagePluginCardsLogger.error("\(error)")
            return
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
        
        MoEngagePluginCardsLogger.debug("Card Delivered - ", forData: accountData)
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
        MoEngagePluginCardsLogger.debug("Cards Shown ", forData: cardData)
        do {
            let showData: [String: Any] = try MoEngagePluginCardsUtil.getNestedData(
                fromHybridPayload: cardData,
                forKey: MoEngagePluginCardsContants.card
            )
            let card = try MoEngageHybridSDKCards.buildCardCampaign(fromHybridData: showData)
            self.handler.cardShown(card, forAppID: identifier)
        } catch {
            MoEngagePluginCardsLogger.error("\(error)")
            return
        }
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
        MoEngagePluginCardsLogger.debug("Delete Cards - ", forData: cardsData)
        do {
            let cardsData: [[String: Any]] = try MoEngagePluginCardsUtil.getNestedData(
                fromHybridPayload: cardsData,
                forKey: MoEngagePluginCardsContants.cards
            )
            let cards = cardsData.decodeFromHybrid()
            self.handler.deleteCards(cards, forAppID: identifier) { _, _ in }
        } catch {
            MoEngagePluginCardsLogger.error("\(error)")
            return
        }
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
        MoEngagePluginCardsLogger.debug("Get Cards Info - ", forData: accountData)
        self.handler.getCardsData(
            forAppID: identifier
        ) { cardsData, accountMeta in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: cardsData?.encodeForHybrid() as Any
            )
            MoEngagePluginCardsLogger.debug("Get Cards Info response - ", forData: result)
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
        
        MoEngagePluginCardsLogger.debug("Get Cards Categories - ", forData: accountData)

        self.handler.getCardsCategories(forAppID: identifier) { categories, accountMeta in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.categories: categories
                ]
            )
            MoEngagePluginCardsLogger.debug("Get Cards Categories response - ", forData: result)
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
        MoEngagePluginCardsLogger.debug("Get Cards for Category - ", forData: categoryData)
        do {
            let categoryData: [String: Any] = try MoEngagePluginCardsUtil.getData(fromHybridPayload: categoryData)
            let cardsCategory = try MoEngageCardsCategoryData.decodeFromHybrid(categoryData)

            self.handler.getCards(
                forCategory: cardsCategory.category,
                forAppID: identifier
            ) { cards, accountMeta in
                let result = MoEngagePluginCardsUtil.buildHybridPayload(
                    forIdentifier: identifier,
                    containingData: [
                        MoEngagePluginCardsContants.category: cardsCategory.category,
                        MoEngagePluginCardsContants.cards: cards.encodeForHybrid()
                    ] as [String : Any]
                )
                MoEngagePluginCardsLogger.debug("Get Cards for Category response - ", forData: result)
                completionHandler(result)
            }
        } catch {
            MoEngagePluginCardsLogger.error("\(error)")
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [:] as [String: Any]
            )
            completionHandler(result)
            return
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
        MoEngagePluginCardsLogger.debug("All Categories Enabled - ", forData: accountData)

        self.handler.isAllCategoryEnabled(forAppID: identifier) { isEnabled in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.isAllCategoryEnabled: isEnabled
                ]
            )
            
            MoEngagePluginCardsLogger.debug("All Categories Enabled response - ", forData: result)
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
        MoEngagePluginCardsLogger.debug("Fetch New Cards Count - ", forData: accountData)

        self.handler.getNewCardsCount(forAppID: identifier) { count, accountMeta  in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.newCardsCount: count
                ]
            )
            MoEngagePluginCardsLogger.debug("Fetch New Cards Count response - ", forData: result)
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
        
        MoEngagePluginCardsLogger.debug("Fetch Unclicked Cards Count - ", forData: accountData)

        self.handler.getUnclickedCardsCount(forAppID: identifier) { count, accountMeta  in
            let result = MoEngagePluginCardsUtil.buildHybridPayload(
                forIdentifier: identifier,
                containingData: [
                    MoEngagePluginCardsContants.unClickedCardsCount: count
                ]
            )
            MoEngagePluginCardsLogger.debug("Fetch Unclicked Cards Count response - ", forData: result)
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

    func fetchCards(
        forAppID appID: String?,
        withCompletion completionBlock: ((_ data: MoEngageCardData?) -> Void)?
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
