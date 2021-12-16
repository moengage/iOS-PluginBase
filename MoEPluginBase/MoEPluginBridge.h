//
//  MoEPluginBridge.h
//  MoEPluginBase
//
//  Created by Chengappa C D on 11/11/16.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MoEngage/MoEngage.h>


@protocol MoEPluginBridgeDelegate <NSObject>
-(void)sendMessageWithName:(NSString*)name andPayload:(NSMutableDictionary*)payloadDict;
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

- (void)pluginInitialized:(NSDictionary*)dict;
- (BOOL)isValidNativeDependencyIntegrated;

- (void)setAppStatus:(NSDictionary*)appStatusDict;
- (void)setAlias:(NSDictionary*)aliasPayloadDict;
- (void)setUserAttributeWithPayload:(NSDictionary*)userAttributeDict;
- (void)trackEventWithPayload:(NSDictionary*)eventPayloadDict;

- (void)registerForPush;

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
