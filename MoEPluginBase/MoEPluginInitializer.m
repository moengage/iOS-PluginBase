//
//  MoEPluginInitializer.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPluginInitializer.h"
#import "MoEPluginConstants.h"
#import "MoEPluginMessageQueueHandler.h"
#import <MoEngage/MoEngage.h>
#import <MOInApp/MOInApp.h>
#import "MOInAppCampaign+Utility.h"

@interface MoEPluginInitializer() <MOInAppNativDelegate, MOMessagingDelegate>
@property(assign, nonatomic) BOOL isSDKIntialized;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSDKIntialized = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushTokenRegistered:) name:MoEngage_Notification_Registered_Notification object:nil];
    }
    return self;
}

// Client Exposed Method
- (void)intializeSDKWithAppID:(NSString*)appID andLaunchOptions:(NSDictionary*)launchOptions{
    self.isSDKIntialized = YES;
    self.moeAppID = appID;
    [self setupSDKWithLaunchOptions:launchOptions];
}

- (void)intializeSDKWithAppID:(NSString*)appID withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions{
    
    if (isSdkEnabled) {
        [[MoEngage sharedInstance] enableSDK];
    }
    else{
        [[MoEngage sharedInstance] disableSDK];
    }
    
    [self intializeSDKWithAppID:appID andLaunchOptions:launchOptions];
}

//this will works as fallback method if Client does not call intializeSDKWithAppID:andLaunchOptions:
- (void)pluginInitialized {
    if (!self.isSDKIntialized) {
        [self setupSDKWithLaunchOptions:nil];
    }
}

-(void)setupSDKWithLaunchOptions:(NSDictionary * _Nullable)launchOptions{
    
    if (@available(iOS 10.0, *)) {
        if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        }
    }
    
    [MOInApp sharedInstance].inAppDelegate = self;
    [MOMessaging sharedInstance].messagingDelegate = self;
    
    // Initialize SDK
    NSString* appID = self.moeAppID;
    if (appID == nil) {
        NSAssert(NO, @"MoEngage - Configure the APP ID for your MoEngage App.To get the AppID login to your MoEngage account, after that go to Settings -> App Settings. You will find the App ID in this screen. And refer to docs.moengage.com for more info");
    }
    
    MOSDKConfig* currentConfig = [[MoEngage sharedInstance] getDefaultSDKConfiguration];
    currentConfig.moeAppID = appID;
#ifdef DEBUG
    [[MoEngage sharedInstance] initializeTestWithConfig:currentConfig andLaunchOptions:launchOptions];
#else
    [[MoEngage sharedInstance] initializeLiveWithConfig:currentConfig andLaunchOptions:launchOptions];
#endif
    
    if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
        [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:[UNUserNotificationCenter currentNotificationCenter].delegate];
    }
}

#pragma mark- Add Messaging Delegate
-(void)notificationClickedWithScreenName:(NSString *)screenName KVPairs:(NSDictionary *)kvPairs andPushPayload:(NSDictionary *)userInfo{
    if (userInfo) {
        NSMutableDictionary* actionPayloadDict = [NSMutableDictionary dictionary];
        if (screenName && screenName.length > 0) {
            actionPayloadDict[@"type"] = @"screenName";
            actionPayloadDict[@"value"] = screenName;
        }
        if (kvPairs) {
            actionPayloadDict[@"kvPair"] = kvPairs;
        }
        
        NSMutableDictionary* clickedAction = [NSMutableDictionary dictionary];
        if ([actionPayloadDict allKeys].count > 0) {
            clickedAction[@"type"] = @"navigation";
            clickedAction[@"payload"] = actionPayloadDict;
        }

        NSDictionary *payload = @{
            @"payload" : userInfo,
            @"clickedAction" : clickedAction
        };
        MoEPluginMessage* pushClick = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushClicked andInfoDict:payload];
        [[MoEPluginMessageQueueHandler sharedInstance] queueMessage:pushClick];
    }
}

#pragma mark- iOS10 UserNotification Framework delegate methods

-(void)pushTokenRegistered:(NSNotification*)notif{
    NSDictionary* userInfo = notif.userInfo;
    if (userInfo != nil) {
        id deviceToken = userInfo[MoEngage_Device_Token_Key];
        NSString* hexToken = nil;
        if ([deviceToken isKindOfClass:[NSData class]]) {
            hexToken = [MOCoreUtils hexTokenForData:deviceToken];
        }
        else{
            hexToken = deviceToken;
        }
        
        if (hexToken != nil && hexToken.length > 0) {
            NSDictionary *payload = @{
                @"token" : hexToken,
                @"pushService" : @"APNS"
            };
            MoEPluginMessage* pushTokenMsg = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushTokenRegistered andInfoDict:payload];
            [[MoEPluginMessageQueueHandler sharedInstance] queueMessage:pushTokenMsg];
        }
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    completionHandler();
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)){
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert ));
}


#pragma mark - MOInAppNativDelegate Methods

-(void)inAppShownWithCampaignInfo:(MOInAppCampaign*)inappCampaign {
    if (inappCampaign) {
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        [payload addEntriesFromDictionary: inappCampaign.dictionaryRepresentation];
        MoEPluginMessage* inAppShownMsg = [[MoEPluginMessage alloc] initWithMethodName:kEventNameInAppCampaignShown andInfoDict:payload];
        [[MoEPluginMessageQueueHandler sharedInstance] queueMessage:inAppShownMsg];
    }
}

-(void)inAppDismissedWithCampaignInfo:(MOInAppCampaign *)inappCampaign{
    NSLog(@"InApp Dismissed with Campaign ID %@",inappCampaign.campaign_id);
    if (inappCampaign) {
        MoEPluginMessage* inAppShownMsg = [[MoEPluginMessage alloc] initWithMethodName:kEventNameInAppCampaignDismissed andInfoDict:inappCampaign.dictionaryRepresentation];
        [[MoEPluginMessageQueueHandler sharedInstance] queueMessage:inAppShownMsg];
    }
}


-(void)inAppClickedWithCampaignInfo:(MOInAppCampaign*)inappCampaign andNavigationActionInfo:(MOInAppAction*)navigationAction {
    [self sendInAppClickWithWithCampaignInfo:inappCampaign navigationAction:navigationAction methodName: kEventNameInAppCampaignClicked];
}

-(void)inAppClickedWithCampaignInfo:(MOInAppCampaign*)inappCampaign andCustomActionInfo:(MOInAppAction*)customAction {
    [self sendInAppClickWithWithCampaignInfo:inappCampaign navigationAction: customAction methodName: kEventNameInAppCampaignCustomAction];
}

-(void)selfHandledInAppTriggeredWithInfo:(MOInAppSelfHandledCampaign*)inappCampaign {
    
    if (inappCampaign) {
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        [payload addEntriesFromDictionary: inappCampaign.dictionaryRepresentation];
        MoEPluginMessage* triggerMesg = [[MoEPluginMessage alloc] initWithMethodName:kEventNameInAppSelfHandledCampaign andInfoDict: payload];
        [[MoEPluginMessageQueueHandler sharedInstance] queueMessage: triggerMesg];
    }
}

#pragma mark - Utility Method -

- (void)sendInAppClickWithWithCampaignInfo:(MOInAppCampaign*)campaign navigationAction:(MOInAppAction *)action methodName:(NSString *)method {
    
    if (campaign) {
        
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

        if (action.keyValuePairs) {
            [dict setObject:action.keyValuePairs forKey:@"kvPair"];
        }
        if (action.actionType == CustomAction) {
            [payload setObject:dict forKey:@"customAction"];
        } else {
            [dict setObject:@"screen" forKey:@"navigationType"];
            if (action.screenName) {
                [dict setObject:action.screenName forKey:@"value"];
            }
            [payload setObject:dict forKey:@"navigation"];
        }
        [payload addEntriesFromDictionary: [campaign dictionaryRepresentation]];
        MoEPluginMessage* inAppClickedMsg = [[MoEPluginMessage alloc] initWithMethodName: method andInfoDict:payload];
        [[MoEPluginMessageQueueHandler sharedInstance] queueMessage:inAppClickedMsg];
    }
}

@end
