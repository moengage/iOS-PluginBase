//
//  MoEReactBridge.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 11/11/16.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <MoEngage/MoEngage.h>
#import "MoEPluginCoordinator.h"
#import "MoEPluginUtils.h"
#import "MoEPluginBridge.h"
#import "MoEPluginConstants.h"
#import "MoEPluginInitializer.h"

@interface MoEPluginBridge()

@end

@implementation MoEPluginBridge

#pragma mark- Initialization

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEPluginBridge *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MoEPluginBridge alloc] init];
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

- (void)pluginInitialized: (NSDictionary*)dict{
    NSString* appID = [MoEPluginUtils getAppID:dict];
    MoEPluginController *controller = [[MoEPluginCoordinator sharedInstance] getPluginController:appID];
    if (!controller.isSDKInitialized || appID.length <= 0) {
        NSAssert(NO, @"MoEngage - Your SDK is not properly initialized. You should call initializeSDKWithConfig:andLaunchOptions: from you AppDelegate didFinishLaunching method. Please refer to doc for more details.");
        [controller pluginInitialized];
    }
    [controller flushMessageQueue];
}


-(MoEPluginController* __nullable) getPluginController:(NSDictionary*)dict {
    NSString* appID = [MoEPluginUtils getAppID:dict];
    MoEPluginController* controller = [[MoEPluginCoordinator sharedInstance] getPluginController:appID];
    return  controller;
}

#pragma mark- Set AppStatus

- (void)setAppStatus:(NSDictionary*)appStatusDict{
    MoEPluginController* controller = [self getPluginController:appStatusDict];
    if (controller != nil) {
       [controller setAppStatus:appStatusDict];
    }
}

#pragma mark- User Attribute Methods

- (void)setUserAttributeWithPayload:(NSDictionary*)userAttributeDict{
    MoEPluginController* controller = [self getPluginController:userAttributeDict];
    if (controller != nil) {
        [controller setUserAttributeWithPayload:userAttributeDict];
    }
    
}

- (void)setAlias:(NSDictionary*)aliasPayloadDict{
    MoEPluginController* controller = [self getPluginController:aliasPayloadDict];
    if (controller != nil) {
        [controller setAlias:aliasPayloadDict];
    }
}


#pragma mark - trackEvent

- (void)trackEventWithPayload:(NSDictionary*)eventPayloadDict{
    MoEPluginController* controller = [self getPluginController:eventPayloadDict];
    if (controller != nil) {
        [controller trackEventWithPayload:eventPayloadDict];
    }
}

#pragma mark- Push Notifications

- (void)registerForPush{
    if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
        MOSDKConfig* sdkConfig = [[MoEngage sharedInstance] getDefaultSDKConfiguration];
        MoEPluginController* controller = [[MoEPluginCoordinator sharedInstance] getPluginController:sdkConfig.moeAppID];
        if (controller != nil) {
           [UNUserNotificationCenter currentNotificationCenter].delegate = controller;
        }
    }
    [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:[UNUserNotificationCenter currentNotificationCenter].delegate];
}

#pragma mark- inApp Methods
#pragma mark Show InApp

- (void)showInApp: (NSDictionary*) inAppDict{
    MoEPluginController* controller = [self getPluginController:inAppDict];
    if (controller != nil) {
        [controller showInApp:inAppDict];
    }
}

#pragma mark InApp Contexts

- (void)setInAppContexts:(NSDictionary*)contextsPayloadDict{
    MoEPluginController* controller = [self getPluginController:contextsPayloadDict];
    if (controller != nil) {
        [controller setInAppContexts:contextsPayloadDict];
    }
}


-(void)invalidateInAppContexts: (NSDictionary*)contextDict {
    MoEPluginController* controller = [self getPluginController:contextDict];
    if (controller != nil) {
        [controller invalidateInAppContexts:contextDict];
    }
}

#pragma mark Self handled In App

- (void)getSelfHandledInApp: (NSDictionary*)inAppDict{
    MoEPluginController* controller = [self getPluginController:inAppDict];
    if (controller != nil) {
        [controller getSelfHandledInApp:inAppDict];
    };
}

- (void)updateSelfHandledInAppStatusWithPayload:(NSDictionary*)selfHandledCampaignDict{
    MoEPluginController* controller = [self getPluginController:selfHandledCampaignDict];
    if (controller != nil) {
        [controller updateSelfHandledInAppStatusWithPayload:selfHandledCampaignDict];
    }
}

#pragma mark- Enable SDK Logs

- (void)enableLogs:(NSDictionary *)logsDict {
    MoEPluginController* controller = [self getPluginController:logsDict];
    if (controller != nil) {
        [controller enableLogs:logsDict];
    }
}

#pragma mark- Reset User

- (void)resetUser: (NSDictionary*)userDict{
    MoEPluginController* controller = [self getPluginController:userDict];
    if (controller != nil) {
        [controller resetUser:userDict];
    }
}

#pragma mark- Opt out Tracking
- (void)optOutTracking:(NSDictionary *)dictTracking {
    MoEPluginController* controller = [self getPluginController:dictTracking];
    if (controller != nil) {
        [controller optOutTracking:dictTracking];
    }
}

#pragma mark- Validate App version

-(BOOL)isValidNativeDependencyIntegrated{
    if ([MoEPluginUtils isCurrentSDKVersionValid]) {
        NSLog(@"MoEngage: Bridge - Valid SDK version integrated.✅");
        return true;
    } else {
        NSLog(@"MoEngage: Bridge - Invalid SDK version integrated.‼️\nSupported SDK versions are from %@ to %@(Not Included) ",kMinSDKVersionSupported,kMaxSDKVersionSupported);
        return false;
    }
}

- (void)updateSDKState:(NSDictionary*)stateInfoDict{
    MoEPluginController* controller = [self getPluginController:stateInfoDict];
    if (controller != nil) {
        [controller updateSDKState:stateInfoDict];
    }
}

@end
