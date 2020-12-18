//
//  MoEPluginBridge.h
//  MoEPluginBase
//
//  Created by Chengappa C D on 11/11/16.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoEPluginBridgeDelegate <NSObject>
-(void)sendMessageWithName:(NSString*)name andPayload:(NSDictionary*)payloadDict;
@end

typedef enum : NSUInteger {
    Cordova,
    Flutter,
    ReactNative,
    Unity,
    Xamarin
} MoEIntegrationType;

@interface MoEPluginBridge : NSObject

+(instancetype)sharedInstance;

@property(nonatomic, weak) id<MoEPluginBridgeDelegate> bridgeDelegate;

- (void)pluginInitialized;
- (void)trackPluginVersion:(NSString*)version forIntegrationType:(MoEIntegrationType)integrationType;
- (BOOL)isValidNativeDependencyIntegrated;

- (void)setAppStatus:(NSDictionary*)appStatusDict;
- (void)setAlias:(NSDictionary*)aliasPayloadDict;
- (void)setUserAttributeWithPayload:(NSDictionary*)userAttributeDict;
- (void)trackEventWithPayload:(NSDictionary*)eventPayloadDict;

- (void)registerForPush;

- (void)showInApp;
- (void)setInAppContexts:(NSDictionary*)contextsPayload;
- (void)invalidateInAppContexts;

- (void)getSelfHandledInApp;
- (void)updateSelfHandledInAppStatusWithPayload:(NSDictionary*)selfHandledCampaignDict;

- (void)startGeofenceMonitoring;

- (void)enableLogs;
- (void)resetUser;
- (void)optOutTracking:(NSDictionary *)dictTracking;

-(void)getInboxMessagesWithCompletionBlock:(void(^) (NSDictionary* inboxMessages))completionBlock;
-(void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo;
-(void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo;
-(NSInteger)getUnreadMessageCount;

- (void)updateSDKState:(NSDictionary*)stateInfo;

@end
