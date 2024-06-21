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
    MoEngageDataCenter yourMoEngageDataCenter = MoEngageDataCenterData_center_01;
    MoEngageSDKConfig* sdkConfig = [[MoEngageSDKConfig alloc] initWithAppId:yourMoEngageAppID dataCenter:yourMoEngageDataCenter];
    sdkConfig.consoleLogConfig = [[MoEngageConsoleLogConfig alloc] initWithIsLoggingEnabled:true loglevel:MoEngageLoggerTypeVerbose];
    MoEngageSDKInitializationConfig* initConfig = [[MoEngageSDKInitializationConfig alloc] initWithSdkConfig:sdkConfig];
    initConfig.launchOptions = launchOptions;
    
    MoEngagePlugin *plugin = [[MoEngagePlugin alloc] init];
    [plugin initializeInstanceWithConfig:initConfig];
    
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
