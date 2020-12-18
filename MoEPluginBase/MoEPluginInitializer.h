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
NS_ASSUME_NONNULL_BEGIN

@interface MoEPluginInitializer : NSObject <UNUserNotificationCenterDelegate>
@property(assign, nonatomic, readonly) BOOL isSDKIntialized;
@property(strong, nonatomic) NSString *moeAppID;

+ (instancetype)sharedInstance;
- (void)intializeSDKWithAppID:(NSString*)appID andLaunchOptions:(NSDictionary*)launchOptions;
- (void)intializeSDKWithAppID:(NSString*)appID withSDKState:(BOOL)isSdkEnabled andLaunchOptions:(NSDictionary*)launchOptions;
- (void)pluginInitialized;
@end

NS_ASSUME_NONNULL_END
