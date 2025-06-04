//
//  MoEngageSDKDefaultInitializationConfig.swift
//  MoEngagePluginBase
//
//  Created by Soumya Ranjan Mahunt on 14/05/24.
//

import Foundation
import MoEngageSDK

/// MoEngage SDK `Info.plist` based default Initialization Configuration
@objcMembers public class MoEngageSDKDefaultInitializationConfig: NSObject {
    /// The state of SDK.
    ///
    /// By default, state is enabled.
    public var sdkState: MoEngageSDKState?
    /// The app launch options.
    ///
    /// By default, no launch options set.
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil

    /// The initialized SDK workspace environment.
    ///
    /// By default, environment set in `Info.plist` file is used.
    public var environment: MoEngageWorkspaceEnvironment = .default
    
    /// Creates a new initialization configuration.
    public override init() {
        super.init()
    }
}
