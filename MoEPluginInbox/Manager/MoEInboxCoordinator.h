//
//  MoEInboxCoordinator.h
//  Pods
//
//  Created by Rakshitha on 20/12/21.
//

#import "MoEInboxCoordinator.h"
#import "MoEInboxController.h"

@interface MoEInboxCoordinator : NSObject

#pragma mark - Shared instance
+ (instancetype _Nonnull)sharedInstance;
- (MoEInboxController* _Nullable)getInboxPluginController:(NSString*_Nullable)appID;
@end

