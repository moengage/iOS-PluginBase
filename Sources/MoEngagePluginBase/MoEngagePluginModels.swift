//
//  MoEngagePluginModels.swift
//  MoEngagePlugin
//
//  Created by Rakshitha on 09/09/22.
//

import Foundation
import MoEngageSDK
import MoEngageInApps
import MoEngageCore

struct MoEngagePluginOptOutData {
    var type: String
    var value: Bool
}

struct MoEngagePluginUserAttributeData {
    var name: String
    var value: Any
    var type: String
}

struct MoEngagePluginUnsetUserAttributeData {
    var name: String
    // nil when the payload has a level that is not supported
    var level: MoEngageUserAttributeLevel?
    // Level as received, echoed back in the reply
    var levelValue: Any
}

struct MoEngagePluginEventData {
    var name: String
    var properties: MoEngageProperties
}

struct MoEngagePluginSelfHandledImpressionData {
    var selfHandledCampaign: MoEngageInAppSelfHandledCampaign
    var impressionType: String
}
