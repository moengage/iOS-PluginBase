//
//  MoEngagePluginGeofenceBridge.swift
//  MoEngageGeofencePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageGeofence
import MoEngagePluginBase

@objc final public class MoEngagePluginGeofenceBridge: NSObject {
    
    @objc public static let sharedInstance = MoEngagePluginGeofenceBridge()
    
    private override init() {
        super.init()
    }
    
    @objc public func startGeofenceMonitoring(_ payload: [String: Any]) {
        let identifier = MoEngagePluginUtils.fetchIdentifierFromPayload(attribute: payload)
        MoEngageSDKGeofence.sharedInstance.startGeofenceMonitoring(forAppID: identifier)
    }
}
