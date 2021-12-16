//
//  MoEGeofenceBridge.h
//  Pods
//
//  Created by Rakshitha on 15/12/21.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoEngageGeofence/MoEngageGeofence-Swift.h>)
    #import <MoEngageGeofence/MoEngageGeofence-Swift.h>
#endif


@interface MoEGeofenceBridge : NSObject
+(instancetype)sharedInstance;
- (void)startGeofenceMonitoring: (NSDictionary*)geofenceDict ;

@end


