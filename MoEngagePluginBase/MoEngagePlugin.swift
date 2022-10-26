//
//  MoEngagePlugin.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

@objc final public class MoEngagePlugin: NSObject {
    
    // MARK: Initialization of default instance
    @objc public func initializeDefaultInstance(sdkConfig: MOSDKConfig, sdkState: MoEngageSDKState, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }
        
        initializeMoEngageDefaultInstance(sdkConfig: sdkConfig, sdkState: sdkState)
    }
    
    @objc public func initializeDefaultInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
        guard !sdkConfig.identifier.isEmpty else { return }
        
        initializeMoEngageDefaultInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
    }
    
    private func initializeMoEngageDefaultInstance(sdkConfig: MOSDKConfig, sdkState: MoEngageSDKState) {
#if DEBUG
        MoEngage.sharedInstance().initializeDefaultTestInstance(with: sdkConfig, andSDKState: sdkState)
#else
        MoEngage.sharedInstance().initializeDefaultLiveInstance(with: sdkConfig, andSDKState: sdkState)
#endif
        
        commonSetUp(identifier: sdkConfig.identifier)
    }
    
    private func initializeMoEngageDefaultInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
#if DEBUG
        MoEngage.sharedInstance().initializeDefaultTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
#else
        MoEngage.sharedInstance().initializeDefaultLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
#endif
        
        commonSetUp(identifier: sdkConfig.identifier)
    }
    
    // MARK: Initialization of secondary instance
    @objc public func initializeInstance(sdkConfig: MOSDKConfig, sdkState: MoEngageSDKState, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }
        
        initializeMoEngageSecondaryInstance(sdkConfig: sdkConfig, sdkState: sdkState)
    }
    
    @objc public func initializeInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }
        
        initializeMoEngageSecondaryInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
    }
    
    private func initializeMoEngageSecondaryInstance(sdkConfig: MOSDKConfig, sdkState: MoEngageSDKState) {
#if DEBUG
        MoEngage.sharedInstance().initializeTestInstance(with: sdkConfig, andSDKState: sdkState)
#else
        MoEngage.sharedInstance().initializeLiveInstance(with: sdkConfig, andSDKState: sdkState)
#endif
        
        commonSetUp(identifier: sdkConfig.identifier)
        
    }
    
    private func initializeMoEngageSecondaryInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
#if DEBUG
        MoEngage.sharedInstance().initializeTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
#else
        MoEngage.sharedInstance().initializeLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
#endif
        
        commonSetUp(identifier: sdkConfig.identifier)
    }
    
    @objc public func trackPluginInfo(_ pluginType: String, version: String) {
        let integrationInfo = MOIntegrationInfo(pluginType: pluginType, version: version)
        MOCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo)
    }
    
    private func commonSetUp(identifier: String) {
        setDelegates(identifier: identifier)
    }
    
    // MARK: Delegate setup
    private func setDelegates(identifier: String) {
        _ = MoEngagePluginInAppDelegateHandler(identifier: identifier)
        _ = MoEngagePluginMessageDelegateHandler(identifier: identifier)
    }
}
