//
//  MoEngagePluginCardsDelegate.swift
//  MoEngagePluginCards
//
//  Created by Rakshitha on 16/08/23.
//

import Foundation
import MoEngagePluginBase

class MoEngagePluginCardsDelegateHandler: MoEngagePluginBaseProtocol {
  
    static func initializePluginBridge() {
        let _ = MoEngagePluginCardsBridge.sharedInstance
    }
}
