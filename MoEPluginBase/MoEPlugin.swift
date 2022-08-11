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
    
    // MARK: Initialization
    @objc public func initializeDefaultInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }

        #if DEBUG
            MoEngage.sharedInstance().initializeDefaultTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
            MoEngage.sharedInstance().initializeDefaultLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        handleSDKState(sdkState, identifier: sdkConfig.identifier)
        
        setDelegates(identifier: sdkConfig.identifier)
    }
    
    @objc public func initializeInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.identifier.isEmpty else { return }

        #if DEBUG
            MoEngage.sharedInstance().initializeTestInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #else
            MoEngage.sharedInstance().initializeLiveInstance(with: sdkConfig, andLaunchOptions: launchOptions)
        #endif
        
        handleSDKState(sdkState, identifier: sdkConfig.identifier)
        
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
