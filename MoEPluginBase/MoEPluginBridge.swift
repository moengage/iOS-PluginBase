//
//  MoEPluginBridge.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK

@objc final public class MoEPluginBridge: NSObject, MoEPluginUtils {
    
    @objc public static let sharedInstance = MoEPluginBridge()
    
    private override init() {
    }
    
    @objc public func pluginInitialized(_ accountInfo: [String: Any]) {
        if let controller = getController(payload: accountInfo) {
            controller.pluginInitialized(accountInfo: accountInfo)
        }
    }
    
    @objc public func setPluginBridgeDelegate(_ delegate: MoEPluginBridgeDelegate, identifier: String) {
        if let controller = MoEPluginCoordinator.sharedInstance.getPluginCoordinator(identifier: identifier) {
            controller.setBridgeDelegate(delegate: delegate)
        }
    }
    
    @objc public func updateSDKState(_ sdkState: [String: Any]) {
        if let controller = getController(payload: sdkState) {
            controller.updateSDKState(sdkState: sdkState)
        }
    }
    
    @objc public func optOutDataTracking(_ dataTrack: [String: Any]) {
        if let controller = getController(payload: dataTrack) {
            controller.optOutDataTracking(dataTrack: dataTrack)
        }
    }
    
    @objc public func setAppStatus(_ appStatus: [String: Any]) {
        if let controller = getController(payload: appStatus) {
            controller.setAppStatus(appStatus: appStatus)
        }
    }
    
    @objc public func setAlias(_ alias: [String: Any]) {
        if let controller = getController(payload: alias) {
            controller.setAlias(alias: alias)
        }
    }
    
    @objc public func setUserAttribute(_ userAttribute: [String: Any]) {
        if let controller = getController(payload: userAttribute) {
            controller.setUserAttribute(userAttribute: userAttribute)
        }
    }
    
    @objc public func trackEvent(_ eventAttribute: [String: Any]) {
        if let controller = getController(payload: eventAttribute) {
            controller.trackEvent(eventAttribute: eventAttribute)
        }
    }
    
    @objc public func resetUser(_ userAttribute: [String: Any]) {
        if let controller = getController(payload: userAttribute) {
            controller.resetUser(userAttribute: userAttribute)
        }
    }
    
    // MARK: InApp
    @objc public func showInApp(_ inApp: [String: Any]) {
        if let controller = getController(payload: inApp) {
            controller.showInApp(inApp: inApp)
        }
    }
    
    @objc public func getSelfHandledInApp(_ inApp: [String: Any]) {
        if let controller = getController(payload: inApp) {
            controller.getSelfHandledInApp(inApp: inApp)
        }
    }
    
    @objc public func setInAppContext(_ context: [String: Any]) {
        if let controller = getController(payload: context) {
            controller.setInAppContext(context: context)
        }
    }
    
    @objc public func resetInAppContext(_ context: [String: Any]) {
        if let controller = getController(payload: context) {
            controller.resetInAppContext(context: context)
        }
    }
    
    @objc public func updateSelfHandledImpression(_ inApp: [String: Any]) {
        if let controller = getController(payload: inApp) {
            controller.updateSelfHandledImpression(inApp: inApp)
        }
    }
    
    // MARK: Push
    @objc public func registerForPush() {
        MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: UNUserNotificationCenter.current().delegate)
    }
    
    private func getController(payload: [String: Any]) -> MoEPluginController? {
        if let appID = MoEPluginBridge.fetchIdentifier(attribute: payload),
           let controller = MoEPluginCoordinator.sharedInstance.getPluginCoordinator(identifier: appID) {
            return controller
            
        }
        return nil
    }
}
