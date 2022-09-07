//
//  MoEngagePluginBridge.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK

@objc final public class MoEngagePluginBridge: NSObject, MoEngagePluginUtils, MoEngagePluginParser, MoEngagePluginMessageDelegate {

    @objc public static let sharedInstance = MoEngagePluginBridge()
    
    private override init() {
    }
    
    @objc public func pluginInitialized(_ accountInfo: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: accountInfo),
           let messageHandler = MoEngagePluginBridge.fetchMessageQueueHandler(identifier: identifier) {
            messageHandler.flushAllMessages()
        }
    }
    
    @objc public func setPluginBridgeDelegate(_ delegate: MoEngagePluginBridgeDelegate, identifier: String) {
        if !identifier.isEmpty {
            let messageHandler = MoEngagePluginBridge.fetchMessageQueueHandler(identifier: identifier)
            messageHandler?.setBridgeDelegate(delegate: delegate)
        }
    }
    
    @objc public func setPluginBridgeDelegate(_ delegate: MoEngagePluginBridgeDelegate, payload: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: payload) {
          setPluginBridgeDelegate(delegate, identifier: identifier)
        }
    }
    
    // MARK: Analytics
    @objc public func updateSDKState(_ sdkState: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: sdkState),
           let sdkState = MoEngagePluginBridge.updateSDKState(sdkState: sdkState) {
            if sdkState {
                MoEngage.sharedInstance().enableSDK(forAppID: identifier)
            } else {
                MoEngage.sharedInstance().disableSDK(forAppID: identifier)
            }
        }
    }
    
    @objc public func optOutDataTracking(_ dataTrack: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: dataTrack),
           let (type, value) = MoEngagePluginBridge.optOutDataTracking(dataTrack: dataTrack) {
            
            if type == MoEngagePluginConstants.SDKState.data {
                if value {
                    MOAnalytics.sharedInstance.disableDataTracking(forAppID: identifier)
                } else {
                    MOAnalytics.sharedInstance.enableDataTracking(forAppID: identifier)
                }
            }
        }
    }
    
    @objc public func setAppStatus(_ appStatus: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: appStatus),
           let appStatus = MoEngagePluginBridge.setAppStatus(appStatus: appStatus) {
            MoEngage.sharedInstance().appStatus(appStatus, forAppID: identifier)
        }
    }
    
    @objc public func setAlias(_ alias: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: alias),
           let alias = MoEngagePluginBridge.setAlias(alias: alias) {
            MOAnalytics.sharedInstance.setAlias(alias, forAppID: identifier)
        }
    }
    
    @objc public func setUserAttribute(_ userAttribute: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: userAttribute),
           let (type, name, value) = MoEngagePluginBridge.setUserAttribute(userAttribute: userAttribute) {
            switch type {
            case MoEngagePluginConstants.UserAttribute.general:
                MOAnalytics.sharedInstance.setUserAttribute(value, withAttributeName: name, forAppID: identifier)
                
            case MoEngagePluginConstants.UserAttribute.timestamp:
                if let timeStamp = value as? String {
                    MOAnalytics.sharedInstance.setUserAttributeISODate(timeStamp, withAttributeName: name, forAppID: identifier)
                }
                
            case MoEngagePluginConstants.UserAttribute.location:
                if let geoLocation = value as? MOGeoLocation {
                    MOAnalytics.sharedInstance.setLocation(geoLocation, withAttributeName: name, forAppID: identifier)
                }
                
            default:
                break
            }
        }
    }
    
    @objc public func trackEvent(_ eventAttribute: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: eventAttribute),
           let (eventName, properties) = MoEngagePluginBridge.trackEvent(eventAttribute: eventAttribute) {
            MOAnalytics.sharedInstance.trackEvent(eventName, withProperties: properties, forAppID: identifier)
        }
    }
    
    @objc public func resetUser(_ userAttribute: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: userAttribute) {
            MOAnalytics.sharedInstance.resetUser(forAppID: identifier)
        }
    }
    
    // MARK: InApp
    @objc public func showInApp(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: inApp) {
            MOInApp.sharedInstance().showInAppCampaign(forAppID: identifier)
        }
    }
    
    @objc public func getSelfHandledInApp(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: inApp) {
            MOInApp.sharedInstance().getSelfHandledInApp(forAppID: identifier) { selfHandledCampaign, _
                in
                let messageHandler = MoEngagePluginBridge.fetchMessageQueueHandler(identifier: identifier)
                let message = MoEngagePluginBridge.fetchSelfHandledPayload(selfHandledCampaign: selfHandledCampaign, identifier: identifier)
                messageHandler?.flushMessage(eventName: MoEngagePluginConstants.CallBackEvents.inAppSelfHandled, message: message)
            }
        }
    }
    
    @objc public func setInAppContext(_ context: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: context),
           let contexts = MoEngagePluginBridge.setInAppContext(context: context) {
            MOInApp.sharedInstance().setCurrentInAppContexts(contexts, forAppID: identifier)
        }
    }
    
    @objc public func resetInAppContext(_ context: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: context) {
            MOInApp.sharedInstance().invalidateInAppContexts(forAppID: identifier)
        }
    }
    
    @objc public func updateSelfHandledImpression(_ inApp: [String: Any]) {
        if let identifier = MoEngagePluginBridge.fetchIdentifier(attribute: inApp),
           let (selfHandledCampaign, impressionType) = MoEngagePluginBridge.updateSelfHandledImpression(inApp: inApp) {
            switch impressionType {
            case MoEngagePluginConstants.InApp.impression:
                MOInApp.sharedInstance().selfHandledShown(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
            case MoEngagePluginConstants.InApp.click:
                MOInApp.sharedInstance().selfHandledClicked(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
            case MoEngagePluginConstants.InApp.dismissed:
                MOInApp.sharedInstance().selfHandledDismissed(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
            default:
                break
            }
        }
    }
    
    // MARK: Push
    @objc public func registerForPush() {
        MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: UNUserNotificationCenter.current().delegate)
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
