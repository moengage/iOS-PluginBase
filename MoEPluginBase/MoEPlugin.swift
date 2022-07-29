//
//  MoEPlugin.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK

@objc final public class MoEPlugin: NSObject {
    @objc public static let sharedInstance = MoEPlugin()
    
    @objc public func initializeDefaultInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [String: Any]) {
        if let controller = MoEPluginCoordinator.sharedInstance.getPluginCoordinator(identifier: sdkConfig.identifier) {
            controller.initializeDefaultInstance(sdkConfig: sdkConfig, sdkState: sdkState, launchOptions: launchOptions)
        }
    }
    
    @objc public func initializeInstance(sdkConfig: MOSDKConfig, sdkState: Bool, launchOptions: [String: Any]) {
        if let controller = MoEPluginCoordinator.sharedInstance.getPluginCoordinator(identifier: sdkConfig.identifier) {
            controller.initializeInstance(sdkConfig: sdkConfig, sdkState: sdkState, launchOptions: launchOptions)
        }
    }
}
