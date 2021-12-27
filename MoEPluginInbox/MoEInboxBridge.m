//
//  MoEInboxBridge.m
//  MoEPluginInbox
//
//  Created by Rakshitha on 14/12/21.
//

#import <Foundation/Foundation.h>
#import <MoEPluginBase/MoEPluginBase.h>
#import "MoEInboxBridge.h"
#import "MoEInboxCoordinator.h"
#import "MoEInboxController.h"

@implementation MoEInboxBridge

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEInboxBridge* instance;
    dispatch_once(&onceToken, ^{
        instance = [[MoEInboxBridge alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark- Inbox Methods

- (void)getInboxMessagesForAccount:(NSDictionary*)inboxDict withCompletionBlock: (void(^) (NSDictionary* inboxMessages))completionBlock{
    MoEInboxController *controller = [self getInboxController:inboxDict];
    [controller getInboxMessagesForAccount:inboxDict withCompletionBlock:^(NSDictionary *inboxMessages) {
        completionBlock(inboxMessages);
    }];
}

- (void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo{
    MoEInboxController *controller = [self getInboxController:campaignInfo];
    [controller trackInboxClickForCampaign:campaignInfo];
}

- (void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo{
    MoEInboxController *controller = [self getInboxController:campaignInfo];
    [controller deleteInboxEntryForCampaign:campaignInfo];
}

- (void)getUnreadMessageCount:(NSDictionary*)inboxDict completionBlock:(void(^) (NSDictionary* inboxDataDict))completionBlock{
    MoEInboxController *controller = [self getInboxController:inboxDict];
    [controller getUnreadMessageCount:inboxDict completionBlock:^(NSDictionary *inboxDataDict) {
        completionBlock(inboxDataDict);
    }];
}

- (MoEInboxController*) getInboxController:(NSDictionary*)inboxDict {
    NSString* appID = [MoEPluginUtils getAppID:inboxDict];
    MoEInboxController *controller = [[MoEInboxCoordinator sharedInstance] getInboxPluginController:appID];
    return  controller;
}

@end
