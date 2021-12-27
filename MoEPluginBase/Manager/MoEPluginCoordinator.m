//
//  MoEPluginCoordinator.m
//  MoEPluginBase
//
//  Created by Rakshitha on 09/12/21.
//

#import <Foundation/Foundation.h>
#import "MoEPluginCoordinator.h"
#import "MoEPluginController.h"
#import "MoEngage/MoEngage.h"
#import <MoEngageObjCUtils/MoEngageObjCUtils.h>

@interface MoEPluginCoordinator()
@property(strong, nonatomic) NSMutableDictionary* pluginControllersDict;
@end

@implementation MoEPluginCoordinator


+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEPluginCoordinator *instance;
    dispatch_once(&onceToken, ^{
        instance = [MoEPluginCoordinator new];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        self.pluginControllersDict = [NSMutableDictionary dictionary];
        
        if (@available(iOS 10.0, *)) {
            if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
                [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            }
        }
        
    }
    return self;
}

- (MoEPluginController* _Nullable)getPluginController:(NSString*)appID{
    if (appID == nil || appID.length <= 0) {
        return nil;
    }
    
    MoEPluginController* controller = [self.pluginControllersDict valueForKey:appID];
    if (controller != nil) {
        return controller;
    } else {
        MoEPluginController* controller = [[MoEPluginController alloc] init];
        self.pluginControllersDict[appID] = controller;
        return controller;
    }
    return nil;
}

#pragma mark- UserNotificationCenter Delegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert ));
}


@end
