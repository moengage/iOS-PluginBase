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
            let sdkConfigData = try? MoEngageConfig.FileBased.fetchSDKConfigurationFromInfoPlist(),
            !sdkConfigData.workspaceId.isEmpty
        else {
            MoEngageLogger.logDefault(message: "App ID is empty. Please provide a valid App ID to setup the SDK.")
            return nil
        }
        return sdkConfigData.asSdkConfig
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

    public static func getInfo(sdkInstance: isolated MoEngageSDKInstance) -> MoEngageModule.Info? {
        return MoEngageModule.Info(identity: .init(name: "pluginBase", version: MoEngagePluginConstants.version))
    }

    public static func process(event: MoEngageModule.Event, sdkInstance: isolated MoEngageSDKInstance) {
        context.execute {
            switch event {
            case .`init`:
                Self.setDelegates(identifier: sdkInstance.config.workspaceId)
            default:
                break
            }
        }
    }

    public static func process(event: MoEngageModule.AsyncEvent, sdkInstance: isolated MoEngageSDKInstance) async {
        // MoEngagePluginBase has no asynchronous lifecycle work.
    }

    public static func listensToAdditionalNotifications() -> [Notification.Name] {
        return []
    }

    private static func setDelegates(identifier: String) {
        _ = MoEngagePluginInAppDelegateHandler(identifier: identifier)
#if os(tvOS)
        MoEngageLogger.logDefault(message: "MoEngagePluginMessageDelegateHandler is unavailable for tvOS 🛑")
#else
    _ = MoEngagePluginMessageDelegateHandler(identifier: identifier)
    // `MoEngageAuthenticationError.Listener` is `@MainActor` isolated in SDK 11, so the
    // conforming handler must be instantiated on the main actor.
    Task { @MainActor in
        _ = MoEngagePluginAuthenticationListenerHandler(identifier: identifier)
    }
#endif
        MoEngagePluginBaseHandler.initializePluginBridge(className: MoEngagePluginConstants.ExternalPluginBase.cardsBridge)
    }
}
