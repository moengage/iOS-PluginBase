//
//  MoEGeofenceBridge.swift
//  MoEngageGeofencePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageGeofence
import MoEPluginBase


@objc public class MoEGeofenceBridge: NSObject {
    
    @objc public static let sharedInstance = MoEGeofenceBridge()
    
    private override init() {
    }
    
    @objc public func startGeofenceMonitoring(_ payload: [String: Any]) {
        let identifier = MoEPluginUtils.sharedInstance.getIdentifier(attribute: payload)
        MOGeofence.sharedInstance.startGeofenceMonitoring(forAppID: identifier)
    }
}
