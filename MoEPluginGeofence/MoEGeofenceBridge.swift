//
//  MoEGeofenceBridge.swift
//  MoEngageGeofencePlugin
//
//  Created by Rakshitha on 23/06/22.
//

import Foundation
import MoEngageGeofence
import MoEPluginBase

@objc final public class MoEGeofenceBridge: NSObject, MoEPluginUtils {
    
    @objc public static let sharedInstance = MoEGeofenceBridge()
    
    private override init() {
        super.init()
    }
    
    @objc public func startGeofenceMonitoring(_ payload: [String: Any]) {
        let identifier = MoEGeofenceBridge.fetchIdentifier(attribute: payload)
        MOGeofence.sharedInstance.startGeofenceMonitoring(forAppID: identifier)
    }
}
