//
//  MoEngagePluginCardsDelegate.swift
//  MoEngagePluginCards
//
//  Created by Rakshitha on 16/08/23.
//

import Foundation
import MoEngagePluginBase

class MoEngagePluginCardsDelegateHandler: MoEngageCardsPluginDelegate {
    override func initializeCardsPlugin() {
       MoEngagePluginCardsBridge.sharedInstance
    }
}
