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
@property(strong, nonatomic) NSMutableDictionary* pluginDictionary;
@end

@implementation MoEPluginCoordinator


+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEPluginCoordinator *instance;
    dispatch_once(&onceToken, ^{
        instance = [MoEPluginCoordinator new];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self != nil) {
        self.pluginDictionary = [NSMutableDictionary dictionary];

    }
    return self;
}


-(MoEPluginController* _Nullable)getPluginController:(NSString*)appID{
    if (appID.length <= 0) {
        return nil;
    }
    
    MoEPluginController* controller = [self.pluginDictionary valueForKey:appID];
    if (controller != nil) {
        return controller;
    }
    else{
        MoEPluginController* controller = [[MoEPluginController alloc] init];
        self.pluginDictionary[appID] = controller;
        return controller;
    }
    return nil;
}


@end
