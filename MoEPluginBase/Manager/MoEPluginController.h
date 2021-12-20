//
//  MoEPluginController.h
//  Pods
//
//  Created by Rakshitha on 09/12/21.
//

#import "MoEngage/MoEngage.h"
#import "MoEPluginMessage.h"

@interface MoEPluginController : NSObject <UNUserNotificationCenterDelegate>
@property(assign, nonatomic) BOOL isSDKInitialized;


-(instancetype)init;

- (void)initializeDefaultSDKWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions;
- (void)initializeSDKWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions;
- (void) flushMessageQueue;
- (void)queueMessage:(MoEPluginMessage*)message;
- (void)pluginInitialized;


- (void)setAppStatus:(NSDictionary*)appStatusDict;
- (void)setAlias:(NSDictionary*)aliasPayloadDict;
- (void)setUserAttributeWithPayload:(NSDictionary*)userAttributeDict;
- (void)trackEventWithPayload:(NSDictionary*)eventPayloadDict;

- (void)showInApp: (NSDictionary*)inAppDict;
- (void)setInAppContexts:(NSDictionary*)contextsPayload;
- (void)invalidateInAppContexts: (NSDictionary*)contextDict;

- (void)getSelfHandledInApp:(NSDictionary*)inAppDict;
- (void)updateSelfHandledInAppStatusWithPayload:(NSDictionary*)selfHandledCampaignDict;


- (void)enableLogs:(NSDictionary*)logsDict;
- (void)resetUser: (NSDictionary*)userDict;
- (void)optOutTracking:(NSDictionary*)dictTracking;

-(void)updateSDKState:(NSDictionary*)stateInfo;
@end
