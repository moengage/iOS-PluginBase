//
//  MoEReactBridge.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 11/11/16.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <MoEngage/MoEngage.h>
#import <MoEngageObjCUtils/MoEngageObjCUtils.h>
#import <MOEngageInApps/MOInApp.h>
#import "MoEPluginCoordinator.h"
#import "MoEPluginUtils.h"
#import "MoEPluginBridge.h"
#import "MoEPluginConstants.h"
#import "MoEPluginInitializer.h"
#import "MoEPluginMessageQueueHandler.h"
#import "MOInAppCampaign+Utility.h"
#import "MOInAppSelfHandledCampaign+Utility.h"

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
    if (!controller.isSDKInitialized) {
        NSAssert(NO, @"MoEngage - Your SDK is not properly initialized. You should call initializeSDKWithConfig:andLaunchOptions: from you AppDelegate didFinishLaunching method. Please refer to doc for more details.");
        [controller pluginInitialized];
    }
    [controller flushMessageQueue];
}

#pragma mark- Set AppStatus

- (void)setAppStatus:(NSDictionary*)appStatusDict{
    if([MoEPluginUtils isValidDictionary:appStatusDict]) {
        
        NSDictionary* dataDict = [MoEPluginUtils getDataDict:appStatusDict];
        NSString *status = [[dataDict getStringForKey:@"appStatus"] uppercaseString];
        
        NSString* appID = [MoEPluginUtils getAppID:appStatusDict];
        
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
        
        NSString* appID = [MoEPluginUtils getAppID: userAttributeDict];
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
        NSString* appdID = [MoEPluginUtils getAppID:eventPayloadDict];
        
        NSDictionary* eventDataDict = [MoEPluginUtils getDataDict: eventPayloadDict];
        NSString *eventName = [eventDataDict getStringForKey:kTrackEventName];
        NSDictionary* attrDict = [eventDataDict validObjectForKey:kEventAttributes];
        
        if ([MoEPluginUtils isValidString:eventName] && [MoEPluginUtils isValidDictionary:attrDict]) {
            NSMutableDictionary *eventAttributes = [attrDict mutableCopy];
            id isNonInteractive = [eventDataDict validObjectForKey:kIsNonInteractive];
            if (isNonInteractive) {
                [eventAttributes setValue:isNonInteractive forKey:kIsNonInteractive];
            }
            
            MOProperties *properties = [[MOProperties alloc] initWithAttributes:eventAttributes];
            [[MoEngage sharedInstance] trackEvent:eventName withProperties:properties forAppID:appdID];
        }
    }
}

#pragma mark- Push Notifications

- (void)registerForPush{
    if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
        MOSDKConfig* sdkConfig = [[MoEngage sharedInstance] getDefaultSDKConfiguration];
        MoEPluginController* controller = [[MoEPluginCoordinator sharedInstance] getPluginController:sdkConfig.moeAppID];
        [UNUserNotificationCenter currentNotificationCenter].delegate = controller;
    }
    [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:[UNUserNotificationCenter currentNotificationCenter].delegate];
}

#pragma mark- inApp Methods
#pragma mark Show InApp

- (void)showInApp: (NSDictionary*) inAppDict{
    NSString* appID = [MoEPluginUtils getAppID:inAppDict];
    [[MOInApp sharedInstance] showInAppCampaignForAppID:appID];
}

#pragma mark InApp Contexts

- (void)setInAppContexts:(NSDictionary*)contextsPayloadDict{
    if ([MoEPluginUtils isValidDictionary:contextsPayloadDict]) {
        NSString* appID = [MoEPluginUtils getAppID:contextsPayloadDict];
        
        NSDictionary* inAppContextDataDict = [MoEPluginUtils getDataDict: contextsPayloadDict];
        NSArray *contexts = [inAppContextDataDict objectForKey:@"contexts"];
        if ([MoEPluginUtils isValidArray: contexts]) {
            [[MOInApp sharedInstance] setCurrentInAppContexts:contexts forAppID:appID];
        }
    }
}


-(void)invalidateInAppContexts: (NSDictionary*)contextDict {
    NSString* appID = [MoEPluginUtils getAppID:contextDict];
    [[MOInApp sharedInstance] invalidateInAppContextsForAppID:appID];
}

#pragma mark Self handled In App

- (void)getSelfHandledInApp: (NSDictionary*)inAppDict{
    NSString* appID = [MoEPluginUtils getAppID: inAppDict];
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
    NSDictionary* dataDict = [MoEPluginUtils getDataDict:logsDict];
    BOOL state = [dataDict getBooleanForKey:@"state"];
    
    [MoEngage enableSDKLogs: state forAppID:appID];
}

#pragma mark- Reset User

- (void)resetUser: (NSDictionary*)userDict{
    NSString* appID = [MoEPluginUtils getAppID: userDict];
    [[MoEngage sharedInstance] resetUserForAppID: appID];
}

#pragma mark- Opt out Tracking
- (void)optOutTracking:(NSDictionary *)dictTracking {
    if ([MoEPluginUtils isValidDictionary:dictTracking]) {
        
        NSDictionary* dataDict = [MoEPluginUtils getDataDict: dictTracking];
        NSString* appID = [MoEPluginUtils getAppID:dictTracking];
        BOOL state = [dataDict getBooleanForKey:@"state"];
        
        if (!state) {
            [[MoEngage sharedInstance] enableDataTrackingForAppID:appID];
        } else  {
            [[MoEngage sharedInstance] disableDataTrackingForAppID:appID];
        }
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
    if ([MoEPluginUtils isValidDictionary:stateInfoDict]) {
        NSString* appID = [MoEPluginUtils getAppID: stateInfoDict];
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
