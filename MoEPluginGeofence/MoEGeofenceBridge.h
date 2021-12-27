//
//  MoEGeofenceBridge.h
//  Pods
//
//  Created by Rakshitha on 15/12/21.
//

#import <Foundation/Foundation.h>
#import <MoEngageGeofence/MoEngageGeofence-Swift.h>


@interface MoEGeofenceBridge : NSObject
+ (instancetype)sharedInstance;
- (void)startGeofenceMonitoring:(NSDictionary*)geofenceDict ;

@end


