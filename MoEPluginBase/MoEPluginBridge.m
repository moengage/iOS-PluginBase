//
//  MoEReactBridge.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 11/11/16.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <MoEngage/MoEngage.h>
#import <MOInApp/MOInApp.h>
#if __has_include(<MOGeofence/MOGeofence.h>)
#import <MOGeofence/MOGeofence.h>
#endif

#import "MoEPluginUtils.h"
#import "MoEPluginBridge.h"
#import "MoEPluginConstants.h"
#import "MoEPluginInitializer.h"
#import "MoEPluginMessageQueueHandler.h"

#import "MOInAppCampaign+Utility.h"
#import "MOInboxModel+Utility.h"
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

- (void)pluginInitialized{
    if (![MoEPluginInitializer sharedInstance].isSDKInitialized) {
        NSAssert(NO, @"MoEngage - Your SDK is not properly initialized. You should call initializeSDKWithConfig:andLaunchOptions: from you AppDelegate didFinishLaunching method. Please refer to doc for more details.");
        [[MoEPluginInitializer sharedInstance] pluginInitialized];
    }
    [[MoEPluginMessageQueueHandler sharedInstance] flushMessageQueue];
}

#pragma mark- Set AppStatus

- (void)setAppStatus:(NSDictionary*)appStatusDict{
    if([MoEPluginUtils isValidDictionary:appStatusDict]) {
        NSString *status = [[appStatusDict getStringForKey:@"appStatus"] uppercaseString];
        if ([status isEqualToString: @"INSTALL"]) {
            [[MoEngage sharedInstance] appStatus:INSTALL];
        } else if ([status isEqualToString: @"UPDATE"]) {
            [[MoEngage sharedInstance] appStatus:UPDATE];
        }
    }
}

#pragma mark- User Attribute Methods

- (void)setUserAttributeWithPayload:(NSDictionary*)userAttributeDict{
    if ([MoEPluginUtils isValidDictionary:userAttributeDict]) {
        
        NSString *type = [[userAttributeDict getStringForKey:@"type"] lowercaseString];
        NSString* attributeName = [userAttributeDict getStringForKey:@"attributeName"];
        NSString *attributeValue = [userAttributeDict getStringForKey:@"attributeValue"];
        
        if ([MoEPluginUtils isValidString:attributeName]) {
            if ([type isEqualToString:@"general"]) {
                if ([MoEPluginUtils isValidString:attributeValue]) {
                    [[MoEngage sharedInstance] setUserAttribute:attributeValue forKey:attributeName];
                }
            } else if ([type isEqualToString:@"timestamp"]) {
                if ([MoEPluginUtils isValidString:attributeValue]) {
                    if (attributeValue) {
                        NSDate *date = [MoEPluginUtils getDateForString:attributeValue];
                        if (date) {
                            [[MoEngage sharedInstance] setUserAttributeDate:date forKey:attributeName];
                        }
                    }
                }
            } else if ([type isEqualToString:@"location"]) {
                NSDictionary *dictLocation = [userAttributeDict objectForKey:@"locationAttribute"];
                if ([MoEPluginUtils isValidDictionary:dictLocation]) {
                    double latitude = [[dictLocation getStringForKey:@"latitude"] doubleValue];
                    double longitude = [[dictLocation getStringForKey:@"longitude"] doubleValue];
                    [[MoEngage sharedInstance] setUserAttributeLocationLatitude:latitude longitude: longitude forKey: attributeName];
                }
            } else {
                NSLog(@"invlaid attribute type in MOReactBridge setUserAttribute");
            }
        }
    }
}

- (void)setAlias:(NSDictionary*)aliasPayloadDict{
    if ([MoEPluginUtils isValidDictionary:aliasPayloadDict]) {
        NSString *alias = [aliasPayloadDict getStringForKey:@"alias"];
        if ([MoEPluginUtils isValidString:alias]) {
            [[MoEngage sharedInstance] setAlias: alias];
        }
    }
}


#pragma mark - trackEvent

- (void)trackEventWithPayload:(NSDictionary*)eventPayloadDict{
    if (eventPayloadDict) {
        NSString *eventName = [eventPayloadDict getStringForKey:kTrackEventName];
        NSDictionary* attrDict = [eventPayloadDict validObjectForKey:kEventAttributes];
        
        if ([MoEPluginUtils isValidString:eventName] && [MoEPluginUtils isValidDictionary:attrDict]) {
            NSMutableDictionary *eventAttributes = [attrDict mutableCopy];
            id isNonInteractive = [eventPayloadDict validObjectForKey:kIsNonInteractive];
            if (isNonInteractive) {
                [eventAttributes setValue:isNonInteractive forKey:kIsNonInteractive];
            }
            
            MOProperties *properties = [[MOProperties alloc] initWithPluginPayloadDict:eventAttributes];
            [[MoEngage sharedInstance] trackEvent: eventName withProperties:properties];
        }
    }
}

#pragma mark- Push Notifications

- (void)registerForPush{
    if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = [MoEPluginInitializer sharedInstance];
    }
    [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:[UNUserNotificationCenter currentNotificationCenter].delegate];
}

#pragma mark- inApp Methods
#pragma mark Show InApp

- (void)showInApp{
    [[MOInApp sharedInstance] showInApp];
}

#pragma mark InApp Contexts

- (void)setInAppContexts:(NSDictionary*)contextsPayloadDict{
    if ([MoEPluginUtils isValidDictionary:contextsPayloadDict]) {
        NSArray *contexts = [contextsPayloadDict objectForKey:@"contexts"];
        if ([MoEPluginUtils isValidArray: contexts]) {
            [[MOInApp sharedInstance] setCurrentInAppContexts:contexts];
        }
    }
}


- (void)invalidateInAppContexts{
    [[MOInApp sharedInstance] invalidateInAppContexts];
}

#pragma mark Self handled In App

- (void)getSelfHandledInApp{
    [MoEPluginUtils dispatchOnMainQueue:^{
        [[MOInApp sharedInstance] getSelfHandledInAppWithCompletionBlock:^(MOInAppSelfHandledCampaign * _Nullable campaignInfo) {
            if (campaignInfo) {
                MoEPluginMessage* selfHandle = [[MoEPluginMessage alloc] initWithMethodName: kEventNameInAppSelfHandledCampaign andInfoDict: campaignInfo.dictionaryRepresentation];
                [[MoEPluginMessageQueueHandler sharedInstance] queueMessage:selfHandle];
            }
        }];
    }];
}

- (void)updateSelfHandledInAppStatusWithPayload:(NSDictionary*)selfHandledCampaignDict{
    NSString* updateType = [selfHandledCampaignDict validObjectForKey:@"type"];
    MOInAppSelfHandledCampaign *info = [[MOInAppSelfHandledCampaign alloc] initWithCampaignInfoDictionary:selfHandledCampaignDict];
    if (updateType && info) {
        if ([updateType isEqualToString:@"impression"]) {
            [[MOInApp sharedInstance] selfHandledShownWithCampaignInfo:info];
        }
        else if ([updateType isEqualToString:@"dismissed"]){
            [[MOInApp sharedInstance] selfHandledDismissedWithCampaignInfo:info];
        }
        else if ([updateType isEqualToString:@"click"]) {
            [[MOInApp sharedInstance] selfHandledClickedWithCampaignInfo:info];
        }
        else if ([updateType isEqualToString:@"primary_clicked"]) {
            [[MOInApp sharedInstance] selfHandledPrimaryClickedWithCampaignInfo:info];
        }
    }
}

#pragma mark- GeoFence Monitoring

- (void)startGeofenceMonitoring{
    // Init Geofence if included
    Class   geofenceHandlerClass    = nil;
    id      geofenceHandler         = nil;
    geofenceHandlerClass = NSClassFromString(@"MOGeofenceHandler");
    if (geofenceHandlerClass != NULL){
        geofenceHandler = [geofenceHandlerClass sharedInstance];
        [geofenceHandler startGeofenceMonitoring];
    }else {
        MOLog(@"MOGeofence Framework unavailable");
    }
}

#pragma mark- Enable SDK Logs

- (void)enableLogs{
    [MoEngage enableSDKLogs:true];
}

#pragma mark- Reset User

- (void)resetUser{
    [[MoEngage sharedInstance] resetUser];
}

#pragma mark- Opt out Tracking
- (void)optOutTracking:(NSDictionary *)dictTracking {
    
    if ([MoEPluginUtils isValidDictionary:dictTracking]) {
        NSString *type = [[dictTracking getStringForKey:@"type"] lowercaseString];
        BOOL state = [dictTracking getBooleanForKey:@"state"];
        
        if ([MoEPluginUtils isValidString:type]) {
            if ([type isEqualToString:@"data"]) {
                [[MoEngage sharedInstance] optOutOfDataTracking:state];
            }
            else if ([type isEqualToString:@"push"]) {
                [[MoEngage sharedInstance] optOutOfMoEngagePushNotification: state];
            }
            else if ([type isEqualToString:@"inapp"]) {
                [[MoEngage sharedInstance] optOutOfInAppCampaign:state];
            }
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

#pragma mark- Inbox Methods

-(void)getInboxMessagesWithCompletionBlock:(void(^) (NSDictionary* inboxMessages))completionBlock{
    if (completionBlock == nil) {
        return;
    }
    
    [MOInbox getInboxMessagesWithCompletionBlock:^(NSArray<MOInboxModel *> *inboxMessages) {
        NSMutableArray* messages = [NSMutableArray array];
        if (inboxMessages && inboxMessages.count > 0) {
            for (MOInboxModel* inboxEntry in inboxMessages) {
                NSDictionary* pluginDictEntry = [inboxEntry getPluginDictionaryRepresentation];
                if (pluginDictEntry && [pluginDictEntry allKeys].count > 0) {
                    [messages addObject:pluginDictEntry];
                }
            }
        }
        
        NSMutableDictionary* inboxPayloadDict = [NSMutableDictionary dictionary];
        inboxPayloadDict[@"platform"] = @"ios";
        inboxPayloadDict[@"messages"] = messages;
        completionBlock(inboxPayloadDict);
    }];
}

-(void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo{
    if (campaignInfo && [campaignInfo allKeys].count > 0) {
        NSString* cid = [campaignInfo validObjectForKey:kInboxKeyCampaignID];
        if (cid && cid.length > 0) {
            [MOInbox trackInboxNotificationClickWithCampaignID:cid];
        }
        else{
            MOLog(@"Campaign ID Not Present‼️");
        }
    }
}

-(void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo{
    if (campaignInfo && [campaignInfo allKeys].count > 0) {
        NSString* cid = [campaignInfo validObjectForKey:kInboxKeyCampaignID];
        if (cid && cid.length > 0) {
            [MOInbox removeMessageWithCampaignID:cid];
        }
        else{
            MOLog(@"Campaign ID Not Present‼️");
        }
    }
}

-(NSInteger)getUnreadMessageCount{
    return [MOInbox getUnreadNotifictionCount];
}

- (void)updateSDKState:(NSDictionary*)stateInfo{
    if ([MoEPluginUtils isValidDictionary:stateInfo]) {
        BOOL state = [stateInfo getBooleanForKey:@"isSdkEnabled"];
        if (state) {
            [[MoEngage sharedInstance] enableSDK];
        }
        else{
            [[MoEngage sharedInstance] disableSDK];
        }
    }
}

@end
