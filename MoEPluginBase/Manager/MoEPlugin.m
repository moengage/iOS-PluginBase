//
//  MoEPlugin.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPlugin.h"
#import "MoEPluginCoordinator.h"
#import "MoEPluginController.h"


@implementation MoEPlugin

#pragma mark- Initialization

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEPlugin *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MoEPlugin alloc] init];
    });
    return instance;
}

#pragma mark - Utility Method -

- (void)initializeDefaultInstanceWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)sdkState andLaunchOptions:(NSDictionary*)launchOptions{
    MoEPluginController *controller = [[MoEPluginCoordinator sharedInstance] getPluginController:sdkConfig.identifier];
    if (controller != nil) {
        [controller initializeDefaultInstanceWithConfig:sdkConfig withSDKState:sdkState andLaunchOptions:launchOptions];
    }
}

- (void)initializeInstanceWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)sdkState andLaunchOptions:(NSDictionary*)launchOptions{
    MoEPluginController *controller = [[MoEPluginCoordinator sharedInstance] getPluginController:sdkConfig.identifier];
    if (controller != nil) {
        [controller initializeInstanceWithConfig:sdkConfig withSDKState:sdkState andLaunchOptions:launchOptions];
    }
}


@end
