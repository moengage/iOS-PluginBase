//
//  MoEPluginCoordinator.h
//  Pods
//
//  Created by Rakshitha on 09/12/21.
//
#import "MoEPluginController.h"

@interface MoEPluginCoordinator : NSObject<UNUserNotificationCenterDelegate>

#pragma mark - Shared instance
+ (instancetype _Nonnull)sharedInstance;
- (MoEPluginController* _Nullable)getPluginController:(NSString*_Nullable)identifier;
@end

