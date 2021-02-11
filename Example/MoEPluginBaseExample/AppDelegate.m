//
//  AppDelegate.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "AppDelegate.h"
#import <MoEPluginBase/MoEPluginBase.h>

@interface AppDelegate()<MoEPluginBridgeDelegate, UNUserNotificationCenterDelegate>

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [[MoEPluginBridge sharedInstance] enableLogs];
    NSString* yourMoEngageAppID = @"DAO6UGZ73D9RTK8B5W96TPYN";
    MOSDKConfig* sdkConfig = [[MOSDKConfig alloc] initWithAppID:yourMoEngageAppID];
   
    [[MoEPluginInitializer sharedInstance] intializeSDKWithConfig: sdkConfig withSDKState:true andLaunchOptions:launchOptions];
    [MoEPluginBridge sharedInstance].bridgeDelegate = self;
    return YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    completionHandler((UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound));
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    completionHandler();
}

-(void)sendMessageWithName:(NSString *)name andPayload:(NSDictionary *)payloadDict{
    NSLog(@"Received Message : ");
    NSLog(@"Message Name : %@",name);
    NSLog(@"Message Payload : %@",payloadDict);
}

@end
