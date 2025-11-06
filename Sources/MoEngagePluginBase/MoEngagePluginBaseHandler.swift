//
//  MoEngagePluginBaseHandler.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 16/08/23.
//  Copyright © 2022 MoEngage. All rights reserved.
//

import Foundation

class MoEngagePluginBaseHandler {
    static func initializePluginBridge(className: String) {
        if let delegateHandler = NSClassFromString(className) as? MoEngagePluginBaseProtocol.Type {
            delegateHandler.initializePluginBridge()
        }
    }
}
