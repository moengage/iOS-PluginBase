//
//  MoEPluginInitializer.h
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import <MoEngage/MoEngage.h>
NS_ASSUME_NONNULL_BEGIN

@interface MoEPluginInitializer : NSObject <UNUserNotificationCenterDelegate>
@property(assign, nonatomic, readonly) BOOL isSDKIntialized;
@property(strong, nonatomic) NSString *moeAppID;
@property(nonatomic, assign) MOSDKConfig *sdkConfig;

+ (instancetype)sharedInstance;
- (void)intializeSDKWithConfig:(MOSDKConfig*)sdkConfig andLaunchOptions:(NSDictionary*)launchOptions;
- (void)intializeSDKWithConfig:(MOSDKConfig*)sdkConfig withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions;
- (void)pluginInitialized;
@end

NS_ASSUME_NONNULL_END
