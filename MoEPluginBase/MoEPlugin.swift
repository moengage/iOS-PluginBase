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
    
    // MARK: Initialization of default instance
    @objc public func initializeDefaultInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }
        
        initializeMoEngageDefaultInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
        
        handleSDKState(sdkState, identifier: sdkConfig.identifier)
    }
    
    @objc public func initializeDefaultInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
     
        guard !sdkConfig.identifier.isEmpty else { return }

        initializeMoEngageDefaultInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
    }
    
    private func initializeMoEngageDefaultInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {

        #if DEBUG
            MoEngage.sharedInstance().initializeDefaultTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
            MoEngage.sharedInstance().initializeDefaultLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        setDelegates(identifier: sdkConfig.identifier)
    }
    
    // MARK: Initialization of secondary instance
    @objc public func initializeInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }

        initializeMoEngageSecondaryInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
        
        handleSDKState(sdkState, identifier: sdkConfig.identifier)
    }
    
    @objc public func initializeInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }
        
        initializeMoEngageSecondaryInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
    }
    
    private func initializeMoEngageSecondaryInstance(sdkConfig: MOSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        #if DEBUG
            MoEngage.sharedInstance().initializeTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
            MoEngage.sharedInstance().initializeLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        setDelegates(identifier: sdkConfig.identifier)
    }
    
    @objc public func trackPluginInfo(_ pluginType: String, version: String) {
        let integrationInfo = MOIntegrationInfo(pluginType: pluginType, version: version)
        MOCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo)
    }
    
    // MARK: Delegate setup
    private func setDelegates(identifier: String) {
        _ = MoEPluginInAppDelegateHandler(identifier: identifier)
        _ = MoEPluginMessageDelegateHandler(identifier: identifier)
    }
    
    private func handleSDKState(_ sdkState: Bool, identifier: String) {
        if sdkState {
            MoEngage.sharedInstance().enableSDK(forAppID: identifier)
        } else {
            MoEngage.sharedInstance().disableSDK(forAppID: identifier)
        }
    }
}
