//
//  AppDelegate.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "AppDelegate.h"
#import <MoEPluginBase/MoEPluginBase.h>

@interface AppDelegate()<MoEPluginBridgeDelegate>

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   [[MoEPluginBridge sharedInstance] enableLogs];
    [[MoEPluginInitializer sharedInstance] intializeSDKWithAppID:@"DAO6UGZ73D9RTK8B5W96TPYN" andLaunchOptions:launchOptions];
    [MoEPluginBridge sharedInstance].bridgeDelegate = self;
    return YES;
}

-(void)sendMessageWithName:(NSString *)name andPayload:(NSDictionary *)payloadDict{
    NSLog(@"Received Message : ");
    NSLog(@"Message Name : %@",name);
    NSLog(@"Message Payload : %@",payloadDict);
}

@end
