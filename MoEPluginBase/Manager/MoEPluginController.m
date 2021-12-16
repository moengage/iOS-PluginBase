//
//  MoEPluginController.m
//  MoEPluginBase
//
//  Created by Rakshitha on 09/12/21.
//

#import <Foundation/Foundation.h>
#import "MoEPluginController.h"
#import "MoEPluginMessage.h"
#import "MoEPluginUtils.h"
#import "MoEngage/MoEngage.h"
#import "MOInAppCampaign+Utility.h"
#import "MoEPluginConstants.h"
#import "MoEPluginMessageQueueHandler.h"
#import "MoEngage/MoEngage.h"
#import "MoEPluginCoordinator.h"
@import MoEngageObjCUtils;

@interface MoEPluginController()<MOInAppNativDelegate, MOMessagingDelegate>
@property(nonatomic, strong) MoEPluginMessageQueueHandler* messageHandler;


@end

@implementation MoEPluginController

- (instancetype)init {
    self.messageHandler = [[MoEPluginMessageQueueHandler alloc]init];
    return self;
}

-(void) flushMessageQueue {
    [self.messageHandler flushMessageQueue];
}

-(void)queueMessage:(MoEPluginMessage*)message {
    [self.messageHandler queueMessage:message];
}

- (void)initializeSDKWithConfig:(MOSDKConfig*)sdkConfig isSecondaryInstance:(BOOL)isSecondary andLaunchOptions:(NSDictionary*)launchOptions {
    self.isSDKInitialized = YES;
    [self setupSDKWithLaunchOptions:sdkConfig isSecondaryInstance:isSecondary launchOptions:launchOptions];
}

- (void)initializeDefaultSDKWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions{
    
    [self handleSDKState:isSdkEnabled];

    [self initializeSDKWithConfig:sdkConfig isSecondaryInstance:false andLaunchOptions:launchOptions];
}

- (void)handleSDKState:(BOOL)isSdkEnabled {
    if (isSdkEnabled) {
        [[MoEngage sharedInstance] enableSDK];
    }
    else{
        [[MoEngage sharedInstance] disableSDK];
    }
}

- (void)initializeSDKWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions{
    
    [self handleSDKState:isSdkEnabled];
    
    [self initializeSDKWithConfig:sdkConfig isSecondaryInstance:true andLaunchOptions:launchOptions];
}


//this will works as fallback method if Client does not call initializeSDKWithAppID:andLaunchOptions:
- (void)pluginInitialized {
    if (!self.isSDKInitialized) {
        [self setupSDKWithLaunchOptions:nil isSecondaryInstance:false launchOptions: nil];
    }
}

-(void)setupSDKWithLaunchOptions:(MOSDKConfig *)sdkConfig isSecondaryInstance:(BOOL)isSecondary launchOptions:(NSDictionary * _Nullable)launchOptions{
    if (@available(iOS 10.0, *)) {
        if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        }
    }
    
    
    // Initialize SDK
    NSString* appID = sdkConfig.moeAppID;
    if (appID == nil) {
        NSAssert(NO, @"MoEngage - Configure the APP ID for your MoEngage App.To get the AppID login to your MoEngage account, after that go to Settings -> App Settings. You will find the App ID in this screen. And refer to docs.moengage.com for more info");
    }
    
   

#ifdef DEBUG
    if (isSecondary) {
        [[MoEngage sharedInstance] initializeTestInstanceWithConfig:sdkConfig andLaunchOptions:launchOptions];
    } else {
        [[MoEngage sharedInstance] initializeDefaultTestInstanceWithConfig:sdkConfig andLaunchOptions:launchOptions];
    }
#else
    if (isSecondary) {
        [[MoEngage sharedInstance] initializeLiveInstanceWithConfig:sdkConfig andLaunchOptions:launchOptions];
    } else {
        [[MoEngage sharedInstance] initializeDefaultLiveInstanceWithConfig: sdkConfig andLaunchOptions:launchOptions];
    }
#endif
    
    [[MOMessaging sharedInstance] setMessagingDelegate:self forAppID:sdkConfig.moeAppID];
    [[MOInApp sharedInstance] setInAppDelegate:self forAppID:sdkConfig.moeAppID];
    
    if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
        [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:[UNUserNotificationCenter currentNotificationCenter].delegate];
    }
}

#pragma mark- Add Messaging Delegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert ));
}


- (void)notificationRegisteredWithDeviceToken:(NSString *)deviceToken {
    if (deviceToken.length > 0) {
        NSDictionary *payload = @{
            @"token" : deviceToken,
            @"pushService" : @"APNS"
        };
        
        MoEPluginMessage* pushTokenMsg = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushTokenGenerated withInfoDict:payload andAccountMeta:nil];
        [_messageHandler queueMessage:pushTokenMsg];
    }
}

- (void)notificationReceivedWithPushPayload:(NSDictionary *)userInfo {
    NSDictionary *payloadDict = @ {
        @"payload": userInfo
    };
    
    NSString * appID = [MoEPluginUtils getAppIDFromNotificationPayload:userInfo];
    
    MOAccountMeta* accountMeta = [[MOAccountMeta alloc] initWithInstanceID: appID];
    MoEPluginMessage* pushClick = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushReceived withInfoDict:payloadDict andAccountMeta: accountMeta];
    [_messageHandler queueMessage:pushClick];
}

- (void)notificationClickedWithScreenName:(NSString *)screenName kvPairs:(NSDictionary *)kvPairs andPushPayload:(NSDictionary *)userInfo {
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
        
        NSString * appID = [MoEPluginUtils getAppIDFromNotificationPayload:userInfo];
        
        MOAccountMeta* accountMeta = [[MOAccountMeta alloc] initWithInstanceID: appID];
        MoEPluginMessage* pushClick = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushClicked withInfoDict:payload andAccountMeta: accountMeta];
        [_messageHandler queueMessage:pushClick];
    }
}


#pragma mark - MOInAppNativDelegate Methods

- (void)inAppShownWithCampaignInfo:(MOInAppCampaign *)inappCampaign forAccountMeta:(MOAccountMeta *)accountMeta {
    if (inappCampaign) {
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        [payload addEntriesFromDictionary: inappCampaign.dictionaryRepresentation];
        MoEPluginMessage* inAppShownMsg = [[MoEPluginMessage alloc] initWithMethodName:kEventNameInAppCampaignShown withInfoDict:payload andAccountMeta:accountMeta];
        [_messageHandler queueMessage:inAppShownMsg];
    }
}

- (void)inAppDismissedWithCampaignInfo:(MOInAppCampaign *)inappCampaign forAccountMeta:(MOAccountMeta *)accountMeta {
    NSLog(@"InApp Dismissed with Campaign ID %@",inappCampaign.campaign_id);
    if (inappCampaign) {
        MoEPluginMessage* inAppShownMsg = [[MoEPluginMessage alloc] initWithMethodName:kEventNameInAppCampaignDismissed withInfoDict:inappCampaign.dictionaryRepresentation andAccountMeta:accountMeta];
        [_messageHandler queueMessage:inAppShownMsg];
    }
}

- (void)inAppClickedWithCampaignInfo:(MOInAppCampaign *)inappCampaign andNavigationActionInfo:(MOInAppAction *)navigationAction forAccountMeta:(MOAccountMeta *)accountMeta {
    [self sendInAppClickWithWithCampaignInfo:inappCampaign navigationAction:navigationAction methodName: kEventNameInAppCampaignClicked withAccountMeta:accountMeta];
}

- (void)inAppClickedWithCampaignInfo:(MOInAppCampaign *)inappCampaign andCustomActionInfo:(MOInAppAction *)customAction forAccountMeta:(MOAccountMeta *)accountMeta {
    [self sendInAppClickWithWithCampaignInfo:inappCampaign navigationAction: customAction methodName: kEventNameInAppCampaignCustomAction withAccountMeta: accountMeta];
}

- (void)selfHandledInAppTriggeredWithInfo:(MOInAppSelfHandledCampaign *)inappCampaign forAccountMeta:(MOAccountMeta *)accountMeta {
    if (inappCampaign) {
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        [payload addEntriesFromDictionary: inappCampaign.dictionaryRepresentation];
        MoEPluginMessage* triggerMesg = [[MoEPluginMessage alloc] initWithMethodName:kEventNameInAppSelfHandledCampaign withInfoDict:payload andAccountMeta:accountMeta];
        [_messageHandler queueMessage: triggerMesg];
    }
}

#pragma mark - Utility Method -

- (void)sendInAppClickWithWithCampaignInfo:(MOInAppCampaign*)campaign navigationAction:(MOInAppAction *)action methodName:(NSString *)method withAccountMeta:(MOAccountMeta*) accountMeta {
    
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
        MoEPluginMessage* inAppClickedMsg = [[MoEPluginMessage alloc] initWithMethodName: method withInfoDict:payload andAccountMeta:accountMeta];
        [_messageHandler queueMessage:inAppClickedMsg];
    }
}



@end
