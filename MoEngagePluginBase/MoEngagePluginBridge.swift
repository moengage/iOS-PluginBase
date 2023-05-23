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
           let messageHandler = MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier) {
            messageHandler.flushAllMessages()
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
                MoEngageSDKAnalytics.sharedInstance.setUserAttribute(userAttribute.value, withAttributeName: userAttribute.name, forAppID: identifier)
                
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
    
    @objc public func getSelfHandledInApp(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: inApp) {
            MoEngageSDKInApp.sharedInstance.getSelfHandledInApp(forAppId: identifier) { campaignInfo, accountMeta in
                let messageHandler = MoEngagePluginMessageDelegate.fetchMessageQueueHandler(identifier: identifier)
                let message = MoEngagePluginUtils.selfHandledCampaignToJSON(selfHandledCampaign: campaignInfo, identifier: identifier)
                messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppSelfHandled, message: message)
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
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: UNUserNotificationCenter.current().delegate)
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
