//
//  AppDelegate.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "AppDelegate.h"
@import MoEngagePluginBase;
@import MoEngageSDK;
@import UserNotifications;

@interface AppDelegate()< UNUserNotificationCenterDelegate, MoEngagePluginBridgeDelegate>

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    //Primary Instance
    NSString* yourMoEngageAppID = @"";
    MoEngageSDKConfig* sdkConfig = [[MoEngageSDKConfig alloc] initWithAppID:yourMoEngageAppID];
    sdkConfig.consoleLogConfig = [[MoEngageConsoleLogConfig alloc] initWithIsLoggingEnabled:true loglevel:MoEngageLoggerTypeVerbose];
    
    MoEngagePlugin *plugin = [[MoEngagePlugin alloc] init];
    [plugin initializeDefaultInstanceWithSdkConfig:sdkConfig sdkState:MoEngageSDKStateEnabled launchOptions:launchOptions];
    
    [[MoEngagePluginBridge sharedInstance] setPluginBridgeDelegate:self identifier:yourMoEngageAppID];
    
    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler((UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound));
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    [[MoEngageSDKMessaging sharedInstance] userNotificationCenter: center didReceive: response];
    completionHandler();
}

- (void)sendMessageWithEvent:(NSString *)event message:(NSDictionary<NSString *,id> *)message {
    NSLog(@"Received Message : ");
    NSLog(@"Message Name : %@",event);
    NSLog(@"Message Payload : %@",message);
}

@end
