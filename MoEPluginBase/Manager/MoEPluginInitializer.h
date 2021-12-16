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

@interface MoEPluginInitializer : NSObject

+ (instancetype)sharedInstance;
- (void)initializeDefaultSDKWithConfig:(MOSDKConfig*)sdkConfig  withSDKState:(BOOL)sdkState andLaunchOptions:(NSDictionary*)launchOptions;
- (void)initializeSDKWithConfig:(MOSDKConfig*)sdkConfig  withSDKState:(BOOL)sdkState andLaunchOptions:(NSDictionary*)launchOptions;
@end

NS_ASSUME_NONNULL_END
