//
//  MoEngageSDKInitializationConfig.swift
//  MoEngagePluginBase
//
//  Created by Soumya Ranjan Mahunt on 14/05/24.
//

import Foundation
import MoEngageSDK

/// MoEngage SDK Initialization Configuration
@objcMembers public class MoEngageSDKInitializationConfig: NSObject {
    /// The SDK configuration to be used.
    public let sdkConfig: MoEngageSDKConfig
    /// The state of SDK.
    ///
    /// By default, state is enabled.
    public var sdkState: MoEngageSDKState = .enabled
    /// The app launch options.
    ///
    /// By default, no launch options set..
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil

    /// Whether the initialized SDK should use test environment.
    ///
    /// By default, test environment is used only on `DEBUG` build configuration.
#if DEBUG
    public var isTestEnvironment: Bool = true
#else
    public var isTestEnvironment: Bool = false
#endif

    /// Whether the initialized SDK instance is default instance.
    ///
    /// By default. set as `true`.
    public var isDefaultInstance: Bool = true
    
    /// Creates a new initialization configuration with provided SDK configuration and default options.
    /// - Parameter sdkConfig: The SDK configuration to be used
    public init(sdkConfig: MoEngageSDKConfig) {
        self.sdkConfig = sdkConfig
    }
}
