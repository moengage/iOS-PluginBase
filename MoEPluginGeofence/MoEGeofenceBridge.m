//
//  MoEGeofenceBridge.m
//  MoEPluginGeofence
//
//  Created by Rakshitha on 15/12/21.
//

#import <Foundation/Foundation.h>
#import "MoEGeofenceBridge.h"
#import <MoEPluginBase/MoEPluginBase.h>

@implementation MoEGeofenceBridge

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEGeofenceBridge* instance;
    dispatch_once(&onceToken, ^{
        instance = [[MoEGeofenceBridge alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)startGeofenceMonitoring: (NSDictionary*)geofenceDict {
    NSString* appID = [MoEPluginUtils getAppID: geofenceDict];
    
    Class   geofenceClass   = nil;
    id      geofence        = nil;
    geofenceClass = NSClassFromString(@"MoEngageGeofence.MOGeofence");
    if (geofenceClass != NULL){
        geofence = [geofenceClass sharedInstance];
        [geofence startGeofenceMonitoringForAppID:appID];
    }else {
        [MOLogger debug:@"MoEngageGeofence Framework unavailable" label:nil sdkConfig:nil];
    }
}
@end
