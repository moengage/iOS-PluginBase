//
//  MoEngagePluginModels.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 09/09/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps

struct MoEngagePluginOptOutData {
    var type: String
    var value: Bool
}

struct MoEngagePluginUserAttributeData {
    var name: String
    var value: Any
    var type: String
}

struct MoEngagePluginEventData {
    var name: String
    var properties: MoEngageProperties
}

struct MoEngagePluginSelfHandledImpressionData {
    var selfHandledCampaign: MoEngageInAppSelfHandledCampaign
    var impressionType: String
}
