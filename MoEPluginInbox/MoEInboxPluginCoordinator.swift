//
//  MoEInboxPluginCoordinator.swift
//  MoEPluginInbox
//
//  Created by Rakshitha on 27/06/22.
//

import Foundation

final class MoEInboxPluginCoordinator {
    
    private var pluginControllers = [String: Any]()
    static let sharedInstance = MoEInboxPluginCoordinator()
    
    private init() {
    }
    
    func getPluginCoordinator(identifier: String) -> MoEInboxPluginController? {
        if identifier.isEmpty {
            assert(false, "MoEngage - Your SDK is not properly initialized. You should call initializeDefaultInstance:andLaunchOptions: from you AppDelegate didFinishLaunching method. Please refer to doc for more details.")
            return nil
        }
        
        if let controller = pluginControllers[identifier] as? MoEInboxPluginController {
            return controller
        } else {
            let controller = MoEInboxPluginController(identifier: identifier)
            pluginControllers[identifier] = controller
            return controller
        }
    }
}
