//
//  AppDelegate.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "AppDelegate.h"
@import MoEngageSegmentPluginBase;
@import  MoEngageSDK;
@import UserNotifications;

@interface AppDelegate()< UNUserNotificationCenterDelegate>

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    //Primary Instance
    NSString* yourMoEngageAppID = @"YOUR APP ID";
    MoEngageSDKConfig* sdkConfig = [[MoEngageSDKConfig alloc] initWithAppID:yourMoEngageAppID];
    sdkConfig.enableLogs = true;
    
    MoEngageSegmentPlugin *plugin = [[MoEngageSegmentPlugin alloc] init];
    [plugin initializeDefaultInstanceWithSdkConfig:sdkConfig sdkState:MoEngageSDKStateEnabled launchOptions:launchOptions];
        
    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler((UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound));
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    [[MoEngageSDKMessaging sharedInstance] userNotificationCenter: center didReceive: response];
    completionHandler();
}
@end
