//
//  AppDelegate.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "AppDelegate.h"
@import MoEPluginBase;
@import MoEngageSDK;

@interface AppDelegate()< UNUserNotificationCenterDelegate, MoEPluginBridgeDelegate>

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    //Primary Instance
    NSString* yourMoEngageAppID = @"";
    MOSDKConfig* sdkConfig = [[MOSDKConfig alloc] initWithAppID:yourMoEngageAppID];
    sdkConfig.enableLogs = true;

    [[[MoEPlugin alloc] init] initializeDefaultInstanceWithSdkConfig:sdkConfig sdkState:true launchOptions:launchOptions];
    [[MoEPluginBridge sharedInstance] setPluginBridgeDelegate:self identifier:yourMoEngageAppID];

    return YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    completionHandler((UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound));
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    completionHandler();
}

- (void)sendMessageWithEvent:(NSString *)event message:(NSDictionary<NSString *,id> *)message {
    NSLog(@"Received Message : ");
    NSLog(@"Message Name : %@",event);
    NSLog(@"Message Payload : %@",message);
}

@end
