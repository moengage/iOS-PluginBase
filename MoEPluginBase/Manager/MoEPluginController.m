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
#import <MoEngageObjCUtils/MoEngageObjCUtils.h>
#import <MOEngageInApps/MOInApp.h>
#import <MoEngageMessaging/MoEngageMessaging-Swift.h>
#import "MOInAppSelfHandledCampaign+Utility.h"


@interface MoEPluginController()<MOInAppNativDelegate, MOMessagingDelegate>
@property(nonatomic, strong) MoEPluginMessageQueueHandler* messageHandler;
@end

@implementation MoEPluginController

- (instancetype)init {
    self.messageHandler = [[MoEPluginMessageQueueHandler alloc] init];
    return self;
}

- (void)flushMessageQueue {
    [self.messageHandler flushMessageQueue];
}

- (void)queueMessage:(MoEPluginMessage*)message {
    [self.messageHandler queueMessage:message];
}

- (void)initializeSDKWithConfig:(MOSDKConfig*)sdkConfig isDefaultInstance:(BOOL)isDefault andLaunchOptions:(NSDictionary*)launchOptions {
    self.isSDKInitialized = YES;
    [self setupSDKWithLaunchOptions:sdkConfig isDefaultInstance:isDefault launchOptions:launchOptions];
}

- (void)initializeDefaultInstanceWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions{
    
    [self handleSDKStateForSDKConfig:sdkConfig isSDKEnabled:isSdkEnabled];
    
    [self initializeSDKWithConfig:sdkConfig isDefaultInstance:true andLaunchOptions:launchOptions];
}

- (void)handleSDKStateForSDKConfig:(MOSDKConfig*)sdkConfig isSDKEnabled:(BOOL)isSdkEnabled {
    NSString* appID = sdkConfig.moeAppID;
    if (isSdkEnabled) {
        [[MoEngage sharedInstance] enableSDKForAppID:appID];
    }
    else{
        [[MoEngage sharedInstance] disableSDKForAppID:appID];
    }
}

- (void)initializeInstanceWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions{
    
    [self handleSDKStateForSDKConfig:sdkConfig isSDKEnabled:isSdkEnabled];
    
    [self initializeSDKWithConfig:sdkConfig isDefaultInstance:false andLaunchOptions:launchOptions];
}


//this will works as fallback method if Client does not call initializeSDKWithAppID:andLaunchOptions:
- (void)pluginInitialized {
    if (!self.isSDKInitialized) {
        [self setupSDKWithLaunchOptions:nil isDefaultInstance:false launchOptions: nil];
    }
}

-(void)setupSDKWithLaunchOptions:(MOSDKConfig *)sdkConfig isDefaultInstance:(BOOL)isDefault launchOptions:(NSDictionary * _Nullable)launchOptions{
    
    NSString* appID = sdkConfig.moeAppID;
    if (appID == nil) {
        NSAssert(NO, @"MoEngage - Configure the APP ID for your MoEngage App.To get the AppID login to your MoEngage account, after that go to Settings -> App Settings. You will find the App ID in this screen. And refer to docs.moengage.com for more info");
    }
    
#ifdef DEBUG
    if (isDefault) {
        [[MoEngage sharedInstance] initializeDefaultTestInstanceWithConfig:sdkConfig andLaunchOptions:launchOptions];
    } else {
        [[MoEngage sharedInstance] initializeTestInstanceWithConfig:sdkConfig andLaunchOptions:launchOptions];
    }
#else
    if (isDefault) {
        [[MoEngage sharedInstance] initializeDefaultLiveInstanceWithConfig:sdkConfig andLaunchOptions:launchOptions];
    } else {
        [[MoEngage sharedInstance] initializeLiveInstanceWithConfig:sdkConfig andLaunchOptions:launchOptions];
        
    }
#endif
    
    [[MOMessaging sharedInstance] setMessagingDelegate:self forAppID:sdkConfig.moeAppID];
    [[MOInApp sharedInstance] setInAppDelegate:self forAppID:sdkConfig.moeAppID];
    
    if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
        [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:[UNUserNotificationCenter currentNotificationCenter].delegate];
    }
}

#pragma mark - Notification Delegate Methods

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
    
    NSString * appID = [MOMessagingUtils getAppIDFromNotificationPayload:userInfo];
    
    MOAccountMeta* accountMeta = [[MOAccountMeta alloc] initWithInstanceID:appID];
    MoEPluginMessage* pushClick = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushReceived withInfoDict:payloadDict andAccountMeta:accountMeta];
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
        
        NSString * appID = [MOMessagingUtils getAppIDFromNotificationPayload:userInfo];
        
        MOAccountMeta* accountMeta = [[MOAccountMeta alloc] initWithInstanceID:appID];
        MoEPluginMessage* pushClick = [[MoEPluginMessage alloc] initWithMethodName:kEventNamePushClicked withInfoDict:payload andAccountMeta:accountMeta];
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
        MoEPluginMessage* inAppClickedMsg = [[MoEPluginMessage alloc] initWithMethodName:method withInfoDict:payload andAccountMeta:accountMeta];
        [_messageHandler queueMessage:inAppClickedMsg];
    }
}

#pragma mark- Set App status
- (void)setAppStatus:(NSDictionary*)appStatusDict{
    if([MoEPluginUtils isValidDictionary:appStatusDict]) {
        
        NSDictionary* dataDict = [MoEPluginUtils getDataDict:appStatusDict];
        NSString *status = [[dataDict getStringForKey:@"appStatus"] uppercaseString];
        
        NSString* appID = [MoEPluginUtils getAppID:appStatusDict];
        
        if (appID == nil || appID.length <= 0) {
            [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
            return;
        }
        
        if ([status isEqualToString: @"INSTALL"]) {
            [[MoEngage sharedInstance] appStatus:AppStatusInstall forAppID: appID];
        } else if ([status isEqualToString: @"UPDATE"]) {
            [[MoEngage sharedInstance] appStatus:AppStatusUpdate forAppID: appID];
        }
    }
}

#pragma mark- User Attribute Methods

- (void)setUserAttributeWithPayload:(NSDictionary*)userAttributeDict{
    if ([MoEPluginUtils isValidDictionary:userAttributeDict]) {
        
        NSString* appID = [MoEPluginUtils getAppID:userAttributeDict];
        
        if (appID == nil || appID.length <= 0) {
            [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
            return;
        }
        
        NSDictionary* userAttributeDataDict = [MoEPluginUtils getDataDict: userAttributeDict];
        NSString *type = [[userAttributeDataDict getStringForKey:@"type"] lowercaseString];
        NSString* attributeName = [userAttributeDataDict getStringForKey:@"attributeName"];
        NSString *attributeValue = [userAttributeDataDict getStringForKey:@"attributeValue"];
        
        if ([MoEPluginUtils isValidString:attributeName]) {
            if ([type isEqualToString:@"general"]) {
                if ([MoEPluginUtils isValidString:attributeValue]) {
                    [[MoEngage sharedInstance] setUserAttribute:attributeValue forKey:attributeName forAppID:appID];
                }
            } else if ([type isEqualToString:@"timestamp"]) {
                if ([MoEPluginUtils isValidString:attributeValue]) {
                    if (attributeValue) {
                        NSDate *date = [MoEPluginUtils getDateForString:attributeValue];
                        if (date) {
                            [[MoEngage sharedInstance] setUserAttributeDate:date forKey:attributeName forAppID:appID];
                        }
                    }
                }
            } else if ([type isEqualToString:@"location"]) {
                NSDictionary *dictLocation = [userAttributeDataDict objectForKey:@"locationAttribute"];
                if ([MoEPluginUtils isValidDictionary:dictLocation]) {
                    double latitude = [[dictLocation getStringForKey:@"latitude"] doubleValue];
                    double longitude = [[dictLocation getStringForKey:@"longitude"] doubleValue];
                    MOGeoLocation *location = [[MOGeoLocation alloc] initWithLatitude:latitude andLongitude:longitude];
                    [[MoEngage sharedInstance] setUserAttributeLocation:location forKey:attributeName forAppID:appID];
                }
            } else {
                NSLog(@"invlaid attribute type in MOReactBridge setUserAttribute");
            }
        }
    }
}

- (void)setAlias:(NSDictionary*)aliasPayloadDict{
    if ([MoEPluginUtils isValidDictionary:aliasPayloadDict]) {
        
        NSString* appID = [MoEPluginUtils getAppID:aliasPayloadDict];
        if (appID == nil || appID.length <= 0) {
            [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
            return;
        }
        
        NSDictionary* aliasDataDict = [MoEPluginUtils getDataDict: aliasPayloadDict];
        NSString *alias = [aliasDataDict getStringForKey:@"alias"];
        
        if ([MoEPluginUtils isValidString:alias]) {
            [[MoEngage sharedInstance] setAlias:alias forAppID:appID];
        }
    }
}


#pragma mark - trackEvent

- (void)trackEventWithPayload:(NSDictionary*)eventPayloadDict{
    if (eventPayloadDict) {
        NSString* appID = [MoEPluginUtils getAppID:eventPayloadDict];
        if (appID == nil || appID.length <= 0) {
            [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
            return;
        }
        
        NSDictionary* eventDataDict = [MoEPluginUtils getDataDict:eventPayloadDict];
        NSString *eventName = [eventDataDict getStringForKey:kTrackEventName];
        NSDictionary* attrDict = [eventDataDict validObjectForKey:kEventAttributes];
        
        if ([MoEPluginUtils isValidString:eventName] && [MoEPluginUtils isValidDictionary:attrDict]) {
            NSMutableDictionary *eventAttributes = [attrDict mutableCopy];
            id isNonInteractive = [eventDataDict validObjectForKey:kIsNonInteractive];
            if (isNonInteractive) {
                [eventAttributes setValue:isNonInteractive forKey:kIsNonInteractive];
            }
            
            MOProperties *properties = [[MOProperties alloc] initWithAttributes:eventAttributes];
            [[MoEngage sharedInstance] trackEvent:eventName withProperties:properties forAppID:appID];
        }
    }
}

#pragma mark- inApp Methods

- (void)showInApp:(NSDictionary*)inAppDict{
    NSString* appID = [MoEPluginUtils getAppID:inAppDict];
    if (appID == nil || appID.length <= 0) {
        [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
        return;
    }
    
    [[MOInApp sharedInstance] showInAppCampaignForAppID:appID];
}

#pragma mark InApp Contexts

- (void)setInAppContexts:(NSDictionary*)contextsPayloadDict{
    if ([MoEPluginUtils isValidDictionary:contextsPayloadDict]) {
        NSString* appID = [MoEPluginUtils getAppID:contextsPayloadDict];
        if (appID == nil || appID.length <= 0) {
            [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
            return;
        }
        
        
        NSDictionary* inAppContextDataDict = [MoEPluginUtils getDataDict: contextsPayloadDict];
        NSArray *contexts = [inAppContextDataDict objectForKey:@"contexts"];
        if ([MoEPluginUtils isValidArray: contexts]) {
            [[MOInApp sharedInstance] setCurrentInAppContexts:contexts forAppID:appID];
        }
    }
}


- (void)invalidateInAppContexts:(NSDictionary*)contextDict {
    NSString* appID = [MoEPluginUtils getAppID:contextDict];
    if (appID == nil || appID.length <= 0) {
        [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
        return;
    }
    
    [[MOInApp sharedInstance] invalidateInAppContextsForAppID:appID];
}

#pragma mark Self handled In App

- (void)getSelfHandledInApp:(NSDictionary*)inAppDict{
    NSString* appID = [MoEPluginUtils getAppID: inAppDict];
    if (appID == nil || appID.length <= 0) {
        [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
        return;
    }
    
    [MoEPluginUtils dispatchOnMainQueue:^{
        [[MOInApp sharedInstance] getSelfHandledInAppForAppID:appID withCompletionBlock:^(MOInAppSelfHandledCampaign * _Nullable campaignInfo, MOAccountMeta * _Nullable accountMeta) {
            if (campaignInfo) {
                MoEPluginMessage* selfHandle = [[MoEPluginMessage alloc] initWithMethodName: kEventNameInAppSelfHandledCampaign withInfoDict:campaignInfo.dictionaryRepresentation andAccountMeta:accountMeta];
                
                MoEPluginController *controller = [[MoEPluginCoordinator sharedInstance] getPluginController:appID];
                [controller queueMessage:selfHandle];
            }
        }];
    }];
}

- (void)updateSelfHandledInAppStatusWithPayload:(NSDictionary*)selfHandledCampaignDict{
    NSString* appID = [MoEPluginUtils getAppID: selfHandledCampaignDict];
    if (appID == nil || appID.length <= 0) {
        [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
        return;
    }
    
    NSDictionary* selfHandledCampaignDataDict = [MoEPluginUtils getDataDict: selfHandledCampaignDict];
    NSString* updateType = [selfHandledCampaignDataDict validObjectForKey:@"type"];
    MOInAppSelfHandledCampaign *info = [[MOInAppSelfHandledCampaign alloc] initWithCampaignInfoDictionary:selfHandledCampaignDict];
    if (updateType && info) {
        if ([updateType isEqualToString:@"impression"]) {
            [[MOInApp sharedInstance] selfHandledShownWithCampaignInfo:info forAppID:appID];
        }
        else if ([updateType isEqualToString:@"dismissed"]){
            [[MOInApp sharedInstance] selfHandledDismissedWithCampaignInfo:info forAppID: appID];
        }
        else if ([updateType isEqualToString:@"click"]) {
            [[MOInApp sharedInstance] selfHandledClickedWithCampaignInfo:info forAppID:appID];
        }
        else if ([updateType isEqualToString:@"primary_clicked"]) {
            [[MOInApp sharedInstance] selfHandledPrimaryClickedWithCampaignInfo:info forAppID:appID];
        }
    }
}

#pragma mark- Enable SDK Logs

- (void)enableLogs:(NSDictionary *)logsDict {
    NSString* appID = [MoEPluginUtils getAppID:logsDict];
    if (appID == nil || appID.length <= 0) {
        [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
        return;
    }
    
    NSDictionary* dataDict = [MoEPluginUtils getDataDict:logsDict];
    BOOL state = [dataDict getBooleanForKey:@"state"];
    
    [MoEngage enableSDKLogs: state forAppID:appID];
}

#pragma mark- Reset User

- (void)resetUser:(NSDictionary*)userDict{
    NSString* appID = [MoEPluginUtils getAppID: userDict];
    if (appID == nil || appID.length <= 0) {
        [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
        return;
    }
    
    [[MoEngage sharedInstance] resetUserForAppID: appID];
}

#pragma mark- Opt out Tracking
- (void)optOutTracking:(NSDictionary *)dictTracking {
    if ([MoEPluginUtils isValidDictionary:dictTracking]) {
        
        NSDictionary* dataDict = [MoEPluginUtils getDataDict: dictTracking];
        NSString* appID = [MoEPluginUtils getAppID:dictTracking];
        
        if (appID == nil || appID.length <= 0) {
            [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
            return;
        }
        
        BOOL state = [dataDict getBooleanForKey:@"state"];
        
        if (!state) {
            [[MoEngage sharedInstance] enableDataTrackingForAppID:appID];
        } else  {
            [[MoEngage sharedInstance] disableDataTrackingForAppID:appID];
        }
    }
}

- (void)updateSDKState:(NSDictionary*)stateInfoDict{
    if ([MoEPluginUtils isValidDictionary:stateInfoDict]) {
        NSString* appID = [MoEPluginUtils getAppID: stateInfoDict];
        if (appID == nil || appID.length <= 0) {
            [MOLogger debug:@"AppID is not available" label:kLoggerPluginBase sdkConfig:nil];
            return;
        }
        
        NSDictionary* dataDict = [MoEPluginUtils getDataDict: stateInfoDict];
        BOOL state = [dataDict getBooleanForKey:@"isSdkEnabled"];
        if (state) {
            [[MoEngage sharedInstance] enableSDKForAppID:appID];
        }
        else{
            [[MoEngage sharedInstance] disableSDKForAppID:appID];
        }
    }
}

@end
