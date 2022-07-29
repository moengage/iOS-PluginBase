//
//  MoEPluginCoordinator.swift
//  MoEPluginBase
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageSDK

final class MoEPluginCoordinator {
    
    private var pluginControllers = [String: Any]()
    static let sharedInstance = MoEPluginCoordinator()
    
    private init() {
    }
    
    func getPluginCoordinator(identifier: String) -> MoEPluginController? {
        if identifier.isEmpty {
            assert(false, "MoEngage - Your SDK is not properly initialized. You should call initializeDefaultInstance:andLaunchOptions: from you AppDelegate didFinishLaunching method. Please refer to doc for more details.")
            return nil
        }
        
        if let controller = pluginControllers[identifier] as? MoEPluginController {
            return controller
        } else {
            let controller = MoEPluginController(identifier: identifier)
            pluginControllers[identifier] = controller
            return controller
        }
    }
}
