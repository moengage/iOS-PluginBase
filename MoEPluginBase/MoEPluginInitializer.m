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
#import <UserNotifications/UserNotifications.h>
#import <MOInApp/MOInApp.h>
#import "MOInAppCampaign+Utility.h"

@interface MoEPluginInitializer() <UNUserNotificationCenterDelegate, MOInAppNativDelegate, MOMessagingDelegate>
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
    }
    return self;
}

// Client Exposed Method
- (void)intializeSDKWithAppID:(NSString*)appID andLaunchOptions:(NSDictionary*)launchOptions{
    self.isSDKIntialized = YES;
    self.moeAppID = appID;
    [self setupSDKWithLaunchOptions:launchOptions];
}

//this will works as fallback method if Client does not call intializeSDKWithAppID:andLaunchOptions:
- (void)pluginInitialized {
    if (!self.isSDKIntialized) {
        [self setupSDKWithLaunchOptions:nil];
    }
}

-(void)setupSDKWithLaunchOptions:(NSDictionary * _Nullable)launchOptions{
    
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    // Add Push Callback Observers
    [self addObserversForPushCallbacks];
    
    // Initialize SDK
    NSString* appID = self.moeAppID;
    if (appID == nil) {
        NSAssert(NO, @"MoEngage - Configure the APP ID for your MoEngage App.To get the AppID login to your MoEngage account, after that go to Settings -> App Settings. You will find the App ID in this screen. And refer to docs.moengage.com for more info");
    }
    
#ifdef DEBUG
    [[MoEngage sharedInstance] initializeDevWithAppID:appID withLaunchOptions:launchOptions];
#else
    [[MoEngage sharedInstance] initializeProdWithAppID:appID withLaunchOptions:launchOptions];
#endif
    
    [MOInApp sharedInstance].inAppDelegate = self;
    [MOMessaging sharedInstance].messagingDelegate = self;
    
    if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
        if (@available(iOS 10.0, *)) {
            [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:self];
        } else {
            [[MoEngage sharedInstance] registerForRemoteNotificationForBelowiOS10WithCategories:nil];
        }
    }
}

#pragma mark- Add Push Observers

-(void)addObserversForPushCallbacks{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationClickedCallback:) name:MoEngage_Notification_Received_Notification object:nil];
}

-(void)notificationClickedCallback:(NSNotification*)notification{
    NSDictionary* pushPayload = notification.userInfo;
    if (pushPayload) {
        NSDictionary *payload = @{
            @"payload" : pushPayload
        };
        MoEPluginMessage* pushClick = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushClicked andInfoDict:payload];
        [[MoEPluginMessageQueueHandler sharedInstance] queueMessage:pushClick];
    }
}

#pragma mark- iOS10 UserNotification Framework delegate methods

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
