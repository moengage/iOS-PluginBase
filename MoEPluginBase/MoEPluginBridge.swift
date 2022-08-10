//
//  MoEPluginBridge.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK

@objc final public class MoEPluginBridge: NSObject, MoEPluginUtils, MoEPluginParser, MoEMessageHandler {

    @objc public static let sharedInstance = MoEPluginBridge()
    
    private override init() {
    }
    
    @objc public func pluginInitialized(_ accountInfo: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: accountInfo),
           let messageHandler = MoEPluginBridge.fetchMessageQueueHandler(identifier: identifier) {
            messageHandler.flushAllMessages()
        }
    }
    
    @objc public func setPluginBridgeDelegate(_ delegate: MoEPluginBridgeDelegate, identifier: String) {
        if let messageHandler = MoEPluginBridge.fetchMessageQueueHandler(identifier: identifier) {
            messageHandler.setBridgeDelegate(delegate: delegate)
        }
    }
    
    //MARK: Analytics
    @objc public func updateSDKState(_ sdkState: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: sdkState),
           let sdkState = MoEPluginBridge.updateSDKState(sdkState: sdkState){
            if sdkState {
                MoEngage.sharedInstance().enableSDK(forAppID: identifier)
            } else {
                MoEngage.sharedInstance().disableSDK(forAppID: identifier)
            }
        }
    }
    
    @objc public func optOutDataTracking(_ dataTrack: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: dataTrack),
           let (type, value) = MoEPluginBridge.optOutDataTracking(dataTrack: dataTrack) {
            
            if type == MoEPluginConstants.SDKState.data {
                if value {
                    MOAnalytics.sharedInstance.enableDataTracking(forAppID: identifier)
                } else {
                    MOAnalytics.sharedInstance.disableDataTracking(forAppID: identifier)
                }
            }
        }
    }
    
    @objc public func setAppStatus(_ appStatus: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: appStatus),
           let appStatus = MoEPluginBridge.setAppStatus(appStatus: appStatus) {
            MoEngage.sharedInstance().appStatus(appStatus, forAppID: identifier)
        }
    }
    
    @objc public func setAlias(_ alias: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: alias),
           let alias = MoEPluginBridge.setAlias(alias: alias) {
            MOAnalytics.sharedInstance.setAlias(alias, forAppID: identifier)
        }
    }
    
    @objc public func setUserAttribute(_ userAttribute: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: userAttribute),
           let (type, name, value) = MoEPluginBridge.setUserAttribute(userAttribute: userAttribute) {
            switch type {
            case MoEPluginConstants.UserAttribute.general:
                MOAnalytics.sharedInstance.setUserAttribute(value, withAttributeName: name, forAppID: identifier)
                
            case MoEPluginConstants.UserAttribute.timestamp:
                if let timeStamp = value as? String {
                    MOAnalytics.sharedInstance.setUserAttributeISODate(timeStamp, withAttributeName: name, forAppID: identifier)
                }
                
            case MoEPluginConstants.UserAttribute.location:
                if let geoLocation = value as? MOGeoLocation {
                    MOAnalytics.sharedInstance.setLocation(geoLocation, withAttributeName: name, forAppID: identifier)
                }
                
            default:
                break
            }
        }
    }
    
    @objc public func trackEvent(_ eventAttribute: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: eventAttribute),
           let (eventName, properties) = MoEPluginBridge.trackEvent(eventAttribute: eventAttribute) {
            MOAnalytics.sharedInstance.trackEvent(eventName, withProperties: properties, forAppID: identifier)
        }
    }
    
    @objc public func resetUser(_ userAttribute: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: userAttribute){
            MOAnalytics.sharedInstance.resetUser(forAppID: identifier)
        }
    }
    
    // MARK: InApp
    @objc public func showInApp(_ inApp: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: inApp){
            MOInApp.sharedInstance().showInAppCampaign(forAppID: identifier)
        }
    }
    
    @objc public func getSelfHandledInApp(_ inApp: [String: Any], completionHandler: @escaping(([String: Any]) -> Void)) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: inApp){
            MOInApp.sharedInstance().getSelfHandledInApp(forAppID: identifier) { selfHandledCampaign, accountMeta
                in
                let message = MoEPluginBridge.fetchSelfHandledPayload(selfHandledCampaign: selfHandledCampaign, identifier: identifier)
                completionHandler(message)
            }
        }
    }
    
    @objc public func setInAppContext(_ context: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: context),
           let contexts = MoEPluginBridge.setInAppContext(context: context) {
            MOInApp.sharedInstance().setCurrentInAppContexts(contexts, forAppID: identifier)
        }
    }
    
    @objc public func resetInAppContext(_ context: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: context) {
            MOInApp.sharedInstance().invalidateInAppContexts(forAppID: identifier)
        }
    }
    
    @objc public func updateSelfHandledImpression(_ inApp: [String: Any]) {
        if let identifier = MoEPluginBridge.fetchIdentifier(attribute: inApp),
           let (selfHandledCampaign, impressionType) = MoEPluginBridge.updateSelfHandledImpression(inApp: inApp) {
            switch impressionType {
            case MoEPluginConstants.InApp.impression:
                MOInApp.sharedInstance().selfHandledShown(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
            case MoEPluginConstants.InApp.click:
                MOInApp.sharedInstance().selfHandledClicked(withCampaignInfo: selfHandledCampaign, forAppID: identifier)
            case MoEPluginConstants.InApp.dismissed:
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
}
