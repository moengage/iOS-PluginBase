//
//  MoEPluginInitializer.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPluginInitializer.h"
#import "MoEPluginCoordinator.h"
#import "MoEPluginController.h"

@interface MoEPluginInitializer()
@end

@implementation MoEPluginInitializer

#pragma mark- Initialization

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEPluginInitializer *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MoEPluginInitializer alloc] init];
    });
    return instance;
}

#pragma mark - Utility Method -

    
- (void)initializeDefaultInstanceWithConfig:(MOSDKConfig*)sdkConfig  withSDKState:(BOOL)sdkState andLaunchOptions:(NSDictionary*)launchOptions{
        MoEPluginController *controller = [[MoEPluginCoordinator sharedInstance] getPluginController:sdkConfig.identifier];
        if (controller != nil) {
            [controller initializeDefaultSDKWithConfig:sdkConfig withSDKState:sdkState andLaunchOptions:launchOptions];
    }
}

- (void)initializeInstanceWithConfig:(MOSDKConfig*)sdkConfig  withSDKState:(BOOL)sdkState andLaunchOptions:(NSDictionary*)launchOptions{
        MoEPluginController *controller = [[MoEPluginCoordinator sharedInstance] getPluginController:sdkConfig.identifier];
        if (controller != nil) {
            [controller initializeSDKWithConfig:sdkConfig withSDKState:sdkState andLaunchOptions:launchOptions];
    }
}


@end
