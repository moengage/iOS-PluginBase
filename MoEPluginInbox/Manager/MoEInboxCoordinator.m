//
//  MoEInboxCoordinator.m
//  MoEPluginInbox
//
//  Created by Rakshitha on 20/12/21.
//

#import <Foundation/Foundation.h>
#import "MoEInboxCoordinator.h"
#import "MoEInboxController.h"

@interface MoEInboxCoordinator()
@property(strong, nonatomic) NSMutableDictionary* inboxControllersDict;
@end

@implementation MoEInboxCoordinator
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEInboxCoordinator *instance;
    dispatch_once(&onceToken, ^{
        instance = [MoEInboxCoordinator new];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        self.inboxControllersDict = [NSMutableDictionary dictionary];

    }
    return self;
}


- (MoEInboxController* _Nullable)getInboxPluginController:(NSString*)appID{
    if (appID == nil || appID.length <= 0) {
        return nil;
    }
    
    MoEInboxController* controller = [self.inboxControllersDict valueForKey:appID];
    if (controller != nil) {
        return controller;
    } else {
        MoEInboxController* controller = [[MoEInboxController alloc] init];
        self.inboxControllersDict[appID] = controller;
        return controller;
    }
    return nil;
}

@end
