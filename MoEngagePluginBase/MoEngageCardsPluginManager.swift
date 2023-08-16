//
//  MoEngageCardsPluginHandler.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 16/08/23.
//  Copyright © 2022 MoEngage. All rights reserved.
//

import Foundation

class MoEngageCardsPluginManager: NSObject {
    
    static let sharedInstance = MoEngageCardsPluginManager()
    var delegate: MoEngageCardsPluginDelegate?
    
    
    private override init() {
        if let delegateHandler = NSClassFromString("MoEngagePluginCards.MoEngagePluginCardsDelegateHandler") as? MoEngageCardsPluginDelegate.Type {
            delegate = delegateHandler.init()
        }
    }

    func initializeCardPlugin() {
        delegate?.initializeCardsPlugin()
    }
}
