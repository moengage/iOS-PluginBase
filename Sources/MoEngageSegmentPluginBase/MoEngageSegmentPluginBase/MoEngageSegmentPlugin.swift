//
//  MoEngageSegmentPlugin.swift
//  MoEngageSegmentPluginBase
//
//  Created by Rakshitha on 09/05/23.
//

import Foundation
import MoEngageSDK
import UIKit

@objc final public class MoEngageSegmentPlugin: NSObject {
    
    // MARK: Initialization of default instance
    @objc public func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig, sdkState: MoEngageSDKState, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.appId.isEmpty else { return }
        
        sdkConfig.setPartnerIntegrationType(integrationType: .segment)
        initializeMoEngageDefaultInstance(sdkConfig: sdkConfig, sdkState: sdkState)
    }
    
    @objc public func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
        guard !sdkConfig.appId.isEmpty else { return }
        
        sdkConfig.setPartnerIntegrationType(integrationType: .segment)
        initializeMoEngageDefaultInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
    }
    
    private func initializeMoEngageDefaultInstance(sdkConfig: MoEngageSDKConfig, sdkState: MoEngageSDKState) {
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig, sdkState: sdkState)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig, sdkState: sdkState)
#endif
        
    }
    
    private func initializeMoEngageDefaultInstance(sdkConfig: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
#endif
        
    }
    
    // MARK: Initialization of secondary instance
    @objc public func initializeInstance(sdkConfig: MoEngageSDKConfig, sdkState: MoEngageSDKState, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.appId.isEmpty else { return }
        
        sdkConfig.setPartnerIntegrationType(integrationType: .segment)
        initializeMoEngageSecondaryInstance(sdkConfig: sdkConfig, sdkState: sdkState)
    }
    
    @objc public func initializeInstance(sdkConfig: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.appId.isEmpty else { return }
        
        sdkConfig.setPartnerIntegrationType(integrationType: .segment)
        initializeMoEngageSecondaryInstance(sdkConfig: sdkConfig, launchOptions: launchOptions)
    }
    
    private func initializeMoEngageSecondaryInstance(sdkConfig: MoEngageSDKConfig, sdkState: MoEngageSDKState) {
#if DEBUG
        MoEngage.sharedInstance.initializeTestInstance(sdkConfig, sdkState: sdkState)
#else
        MoEngage.sharedInstance.initializeLiveInstance(sdkConfig, sdkState: sdkState)
#endif
            
    }
    
    private func initializeMoEngageSecondaryInstance(sdkConfig: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
#if DEBUG
        MoEngage.sharedInstance.initializeTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeLiveInstance(sdkConfig)
#endif
        
    }
    
    @objc public func trackPluginInfo(_ pluginType: String, version: String) {
        let integrationInfo = MoEngageIntegrationInfo(pluginType: pluginType, version: version)
        MoEngageCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo)
    }
}
