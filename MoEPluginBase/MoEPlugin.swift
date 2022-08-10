//
//  MoEPlugin.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

@objc final public class MoEPlugin: NSObject {
    @objc public static let sharedInstance = MoEPlugin()
    
    var inAppDelegateHandler: MoEPluginInAppDelegateHandler?
    var messageDelegateHandler: MoEPluginMessageDelegateHandler?
    
    //MARK: Initialization
    @objc public func initializeDefaultInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [String: Any]) {
        #if DEBUG
            MoEngage.sharedInstance().initializeDefaultTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
            MoEngage.sharedInstance().initializeDefaultLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        handleSDKState(sdkState, identifier: sdkConfig.identifier)
        
        setDelegates(identifier: sdkConfig.identifier)
    }
    
    @objc public func initializeInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [String: Any]) {
        #if DEBUG
            MoEngage.sharedInstance().initializeTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
            MoEngage.sharedInstance().initializeLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        handleSDKState(sdkState, identifier: sdkConfig.identifier)
        
        setDelegates(identifier: sdkConfig.identifier)
    }
    
    //MARK: Delegate setup
    private func setDelegates(identifier: String) {
        setInAppDelegate(identifier: identifier)
        setMessagingDelegate(identifier: identifier)
    }
    
    private func setInAppDelegate(identifier: String) {
        inAppDelegateHandler = MoEPluginInAppDelegateHandler(identifier: identifier)
        MOInApp.sharedInstance().setInAppDelegate(inAppDelegateHandler, forAppID: identifier)
    }
    
    private func setMessagingDelegate(identifier: String) {
        messageDelegateHandler = MoEPluginMessageDelegateHandler(identifier: identifier)
        MOMessaging.sharedInstance.setMessagingDelegate(messageDelegateHandler, forAppID: identifier)
        guard UIApplication.shared.isRegisteredForRemoteNotifications else { return }
        
        if let currentDelegate = UNUserNotificationCenter.current().delegate {
            MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: currentDelegate)
        } else {
            MoEngage.sharedInstance().registerForRemoteNotification(withCategories: nil, withUserNotificationCenterDelegate: messageDelegateHandler)
        }
    }
    
    private func handleSDKState(_ sdkState: Bool, identifier: String) {
        if sdkState {
            MoEngage.sharedInstance().enableSDK(forAppID: identifier)
        } else {
            MoEngage.sharedInstance().disableSDK(forAppID: identifier)
        }
    }
}
