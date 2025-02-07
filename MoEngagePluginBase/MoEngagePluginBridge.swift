//
//  MoEngagePluginBridge.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

@available(iOSApplicationExtension, unavailable)

@objc final public class MoEngagePluginBridge: NSObject {

    @objc public static let sharedInstance = MoEngagePluginBridge()

    private override init() {
    }
    
    @objc public func pluginInitialized(_ accountInfo: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: accountInfo),
           let messageHandler = MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier),
           let initConfig = MoEngagePluginUtils.fetchInitConfig(attribute: accountInfo) {
            MoEngageInitConfigCache.sharedInstance.initializeInitConfig(appID: identifier, initConfig: initConfig)
            messageHandler.flushAllMessages()
        }
        trackIntegrationType(accountInfo)
    }
    
    private func trackIntegrationType(_ payload: [String : Any]) {
        if let integrationInfo = payload[MoEngagePluginConstants.General.integrationMeta] as? [String: Any],
           let type = integrationInfo[MoEngagePluginConstants.General.integrationType] as? String,
           let version = integrationInfo[MoEngagePluginConstants.General.integrationVersion] as? String {
            MoEngagePlugin().trackPluginInfo(type, version: version)
        }
    }
    
    @objc public func setPluginBridgeDelegate(_ delegate: MoEngagePluginBridgeDelegate, identifier: String) {
        if !identifier.isEmpty {
            let messageHandler = MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
            messageHandler?.setBridgeDelegate(delegate: delegate)
        }
    }
    
    @objc public func setPluginBridgeDelegate(_ delegate: MoEngagePluginBridgeDelegate, payload: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload) {
          setPluginBridgeDelegate(delegate, identifier: identifier)
        }
    }
    
    // MARK: Analytics
    @objc public func updateSDKState(_ sdkState: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: sdkState),
           let sdkState = MoEngagePluginParser.fetchSDKState(payload: sdkState) {
            if sdkState {
                MoEngage.sharedInstance.enableSDK(appId: identifier)
            } else {
                MoEngage.sharedInstance.disableSDK(appId: identifier)
            }
        }
    }
    
    @objc public func optOutDataTracking(_ dataTrack: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: dataTrack),
           let optOutPayload = MoEngagePluginParser.mapJsonToOptOutData(payload: dataTrack) {
            
            if optOutPayload.type == MoEngagePluginConstants.SDKState.data {
                if optOutPayload.value {
                    MoEngageSDKAnalytics.sharedInstance.disableDataTracking(forAppID: identifier)
                } else {
                    MoEngageSDKAnalytics.sharedInstance.enableDataTracking(forAppID: identifier)
                }
            }
        }
    }
    
    @objc public func identifyUser(_ identities: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: identities),
           let identitiesDict = MoEngagePluginParser.fetchIdentities(payload: identities) {
            MoEngageSDKAnalytics.sharedInstance.identifyUser(identities: identitiesDict, workspaceId: identifier)
        }
    }

    @objc public func getUserIdentities(_ payload: [String: Any], completionHandler: @escaping ([String: String]) -> Void) {
        guard let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload) else {
            return
        }
        MoEngageSDKAnalytics.sharedInstance.getUserIdentities(workspaceId: identifier) { identities in
            completionHandler(identities)
        }
    }

    @objc public func setAppStatus(_ appStatus: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: appStatus),
           let appStatus = MoEngagePluginParser.fetchAppStatus(payload: appStatus) {
            MoEngageSDKAnalytics.sharedInstance.appStatus(appStatus, forAppID: identifier)
        }
    }
    
    @objc public func setAlias(_ alias: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: alias),
           let alias = MoEngagePluginParser.fetchAlias(payload: alias) {
            MoEngageSDKAnalytics.sharedInstance.setAlias(alias, forAppID: identifier)
        }
    }
    
    @objc public func setUserAttribute(_ userAttribute: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: userAttribute),
           let userAttribute = MoEngagePluginParser.mapJsonToUserAttributeData(payload: userAttribute) {
            switch userAttribute.type {
            case MoEngagePluginConstants.UserAttribute.general:
                let shouldTrackUserAttributeBooleanAsNumber = MoEngageInitConfigCache.sharedInstance.fetchShouldTrackUserAttributeBooleanAsNumber(forAppID: identifier)
                if CFGetTypeID(userAttribute.value as CFTypeRef) == CFBooleanGetTypeID() {
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(shouldTrackUserAttributeBooleanAsNumber ? userAttribute.value as? Double: userAttribute.value as? Bool, withAttributeName: userAttribute.name, forAppID: identifier)
                } else {
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(userAttribute.value, withAttributeName: userAttribute.name, forAppID: identifier)
                }
                
            case MoEngagePluginConstants.UserAttribute.timestamp:
                if let timeStamp = userAttribute.value as? String {
                    MoEngageSDKAnalytics.sharedInstance.setUserAttributeISODate(timeStamp, withAttributeName: userAttribute.name, forAppID: identifier)
                }
                
            case MoEngagePluginConstants.UserAttribute.location:
                if let geoLocation = userAttribute.value as? MoEngageGeoLocation {
                    MoEngageSDKAnalytics.sharedInstance.setLocation(geoLocation, withAttributeName: userAttribute.name, forAppID: identifier)
                }
                
            default:
                break
            }
        }
    }
    
    @objc public func trackEvent(_ eventAttribute: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: eventAttribute),
           let event = MoEngagePluginParser.mapJsonToEventData(payload: eventAttribute) {
            MoEngageSDKAnalytics.sharedInstance.trackEvent(event.name, withProperties: event.properties, forAppID: identifier)
        }
    }
    
    @objc public func resetUser(_ userAttribute: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: userAttribute) {
            MoEngageSDKAnalytics.sharedInstance.resetUser(forAppID: identifier)
        }
    }
    
    // MARK: InApp
    @objc public func showInApp(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inApp) {
            MoEngageSDKInApp.sharedInstance.showInApp(forAppId: identifier)
        }
    }
    
    @objc public func showNudge(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inApp) {
            let position = MoEngagePluginUtils.getNudgePosition(from: inApp)
            #if os(tvOS)
            MoEngageLogger.logDefault(message: "Show Nudge is unavailable for tvOS 🛑")
            #else
            MoEngageSDKInApp.sharedInstance.showNudge(atPosition: position, forAppId: identifier)
            #endif
        }
    }
    
    @objc public func getSelfHandledInApp(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inApp) {
            MoEngageSDKInApp.sharedInstance.getSelfHandledInApp(forAppId: identifier) { campaignInfo, accountMeta in
                let messageHandler = MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
                let message = MoEngagePluginUtils.selfHandledCampaignToJSON(selfHandledCampaign: campaignInfo, identifier: identifier)
                messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppSelfHandled, message: message)
            }
        }
    }
    
    @objc public func getSelfHandledInApps(_ payload: [String: Any], completionBlock: @escaping(([String: Any]) -> Void)) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload) {
            MoEngageSDKInApp.sharedInstance.getSelfHandledInApps(for: identifier) { campaignData in
                let payload = MoEngagePluginUtils.mapSelfHandledCampaignDataToJSON(campaignData: campaignData)
                completionBlock(payload)
            }
        }
    }
    
    @objc public func setInAppContext(_ context: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: context),
           let contexts = MoEngagePluginParser.fetchContextData(payload: context) {
            MoEngageSDKInApp.sharedInstance.setCurrentInAppContexts(contexts, forAppId: identifier)
        }
    }
    
    @objc public func resetInAppContext(_ context: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: context) {
            MoEngageSDKInApp.sharedInstance.invalidateInAppContexts(forAppId: identifier)
        }
    }
    
    @objc public func updateSelfHandledImpression(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inApp),
           let selfHandledImpressionPayload = MoEngagePluginParser.mapJsonToSelfHandledImpressionData(payload: inApp) {
            switch selfHandledImpressionPayload.impressionType {
            case MoEngagePluginConstants.InApp.impression:
                MoEngageSDKInApp.sharedInstance.selfHandledShown(campaignInfo: selfHandledImpressionPayload.selfHandledCampaign, forAppId: identifier)
            case MoEngagePluginConstants.InApp.click:
                MoEngageSDKInApp.sharedInstance.selfHandledClicked(campaignInfo: selfHandledImpressionPayload.selfHandledCampaign, forAppId: identifier)
            case MoEngagePluginConstants.InApp.dismissed:
                MoEngageSDKInApp.sharedInstance.selfHandledDismissed(campaignInfo: selfHandledImpressionPayload.selfHandledCampaign, forAppId: identifier)
            default:
                break
            }
        }
    }
    
    // MARK: Push
    @objc public func registerForPush() {
        #if os(tvOS)
        MoEngageLogger.logDefault(message: "RegisterForPush is unavailable for tvOS 🛑")
        #else
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: UNUserNotificationCenter.current().delegate)
        #endif
    }
    
    @available(iOS 12.0, *)
    @objc public func registerForProvisionalPush() {
        #if os(tvOS)
        MoEngageLogger.logDefault(message: "RegisterForProvisionalPush is unavailable for tvOS 🛑")
        #else
        MoEngageSDKMessaging.sharedInstance.registerForRemoteProvisionalNotification(withCategories: nil, andUserNotificationCenterDelegate: UNUserNotificationCenter.current().delegate)
        #endif
    }
    
    // MARK: Other
    @objc public func validateSDKVersion() -> Bool {
        if MoEngagePluginConstants.SDKVersions.currentVersion >=  MoEngagePluginConstants.SDKVersions.minimumVersion &&  MoEngagePluginConstants.SDKVersions.currentVersion < MoEngagePluginConstants.SDKVersions.maximumVersion {
            return true
        }
        
        print("MoEngage: Plugin Bridge - Native Dependencies not integrated")
        return false
    }
}
