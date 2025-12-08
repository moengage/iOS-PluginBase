//
//  MoEngagePlugin.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

@available(iOSApplicationExtension, unavailable)
@objc final public class MoEngagePlugin: NSObject {
    
    /// Initialize SDK with provided configuration.
    /// - Parameter initializationConfig: The configuration used for initialization.
    @objc public func initializeInstance(
        withConfig initializationConfig: MoEngageSDKInitializationConfig
    ) {
        let sdkConfig = initializationConfig.sdkConfig
        let sdkState = initializationConfig.sdkState
        if initializationConfig.isDefaultInstance {
            if initializationConfig.isTestEnvironment {
                MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig, sdkState: sdkState)
            } else {
                MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig, sdkState: sdkState)
            }
        } else {
            if initializationConfig.isTestEnvironment {
                MoEngage.sharedInstance.initializeTestInstance(sdkConfig, sdkState: sdkState)
            } else {
                MoEngage.sharedInstance.initializeLiveInstance(sdkConfig, sdkState: sdkState)
            }
        }
    }

    /// Initialize default instance SDK with provided `Info.plist` configuration.
    /// - Parameter defaultInitializationConfig: The additional configuration used for initialization.
    @discardableResult
    @objc public func initializeDefaultInstance(
        withAdditionalConfig defaultInitializationConfig: MoEngageSDKDefaultInitializationConfig = MoEngageSDKDefaultInitializationConfig()
    ) -> MoEngageSDKConfig? {
        if let sdkState = defaultInitializationConfig.sdkState {
            MoEngage.sharedInstance.initializeDefaultInstance(sdkState: sdkState)
        } else {
            MoEngage.sharedInstance.initializeDefaultInstance()
        }

        guard
            let sdkConfig = try? MoEngageInitialization.fetchSDKConfigurationFromInfoPlist(),
            !sdkConfig.appId.isEmpty
        else {
            MoEngageLogger.logDefault(message: "App ID is empty. Please provide a valid App ID to setup the SDK.")
            return nil
        }
        return sdkConfig
    }

    // MARK: Initialization of default instance
    @objc public func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig, sdkState: MoEngageSDKState, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.appId.isEmpty else { return }
        
        initializeMoEngageDefaultInstance(sdkConfig: sdkConfig, sdkState: sdkState)
    }
    
    @objc public func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
        guard !sdkConfig.appId.isEmpty else { return }
        
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
        
        initializeMoEngageSecondaryInstance(sdkConfig: sdkConfig, sdkState: sdkState)
    }
    
    @objc public func initializeInstance(sdkConfig: MoEngageSDKConfig, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        guard !sdkConfig.appId.isEmpty else { return }
        
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

extension MoEngagePlugin: MoEngageModule.Item {
    static let context: MoEngageSynchronizationContext = "com.moengage.pluginBase"

    public static func getInfo(sdkInstance: MoEngageSDKInstance) -> MoEngageModule.Info {
        return .init(name: "pluginBase", version: MoEngagePluginConstants.version)
    }

    public static func process(event: MoEngageModule.Event, sdkInstance: MoEngageSDKInstance) {
        context.execute {
            switch event {
            case .`init`:
                Self.setDelegates(identifier: sdkInstance.sdkConfig.appId)
            default:
                break
            }
        }
    }

    private static func setDelegates(identifier: String) {
        _ = MoEngagePluginInAppDelegateHandler(identifier: identifier)
#if os(tvOS)
        MoEngageLogger.logDefault(message: "MoEngagePluginMessageDelegateHandler is unavailable for tvOS 🛑")
#else
    _ = MoEngagePluginMessageDelegateHandler(identifier: identifier)
#endif
        MoEngagePluginBaseHandler.initializePluginBridge(className: MoEngagePluginConstants.ExternalPluginBase.cardsBridge)
    }
}
