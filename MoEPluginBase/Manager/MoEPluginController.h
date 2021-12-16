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
-(void) flushMessageQueue;
-(void)queueMessage:(MoEPluginMessage*)message;
- (void)pluginInitialized;
@end
