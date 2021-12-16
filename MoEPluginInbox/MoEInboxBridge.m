//
//  MoEInboxBridge.m
//  MoEPluginInbox
//
//  Created by Rakshitha on 14/12/21.
//

#import <Foundation/Foundation.h>
#import <MoEPluginBase/MoEPluginBase.h>
#import "MoEInboxBridge.h"
#import "MOInboxEntry+Utility.h"
#import <MoEngageObjCUtils/MoEngageObjCUtils.h>


@implementation MoEInboxBridge

+(instancetype)sharedInstance{
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

-(void)getInboxMessagesForAccount:(NSDictionary*)accountMeta withCompletionBlock: (void(^) (NSDictionary* inboxMessages))completionBlock{
    if (completionBlock == nil) {
        return;
    }
    
    NSString* appID = [MoEPluginUtils getAppID:accountMeta];
    Class   inboxClass   = nil;
    inboxClass = NSClassFromString(@"MoEngageInbox.MOInbox");
    if (inboxClass != NULL) {
        [[inboxClass sharedInstance] getInboxMessagesForAppID:appID withCompletionBlock:^(NSArray<MOInboxEntry *> * _Nonnull inboxMessages, MOAccountMeta * _Nullable accountMeta) {
            NSMutableArray* messages = [NSMutableArray array];
            if (inboxMessages && inboxMessages.count > 0) {
                for (MOInboxEntry* inboxEntry in inboxMessages) {
                    NSDictionary* pluginDictEntry = [inboxEntry getPluginDictionaryRepresentation];
                    if (pluginDictEntry && [pluginDictEntry allKeys].count > 0) {
                        [messages addObject:pluginDictEntry];
                    }
                }
            }

            NSDictionary *accountMetaDict = @ {
            kAppID: appID
            };

            NSDictionary *dataDict =  @ {
                @"platform":@"ios",
                @"messages": messages
            };
            NSDictionary* inboxPayloadDict = @ {
            kAccountMetaKey: accountMetaDict,
            kDataDictKey: dataDict
            };

            completionBlock(inboxPayloadDict);
        }];
    }
}

-(void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo{
    NSString* appID = [MoEPluginUtils getAppID:campaignInfo];
    NSDictionary* dataDict = [MoEPluginUtils getDataDict:campaignInfo];
    
    Class   inboxClass   = nil;
    inboxClass = NSClassFromString(@"MoEngageInbox.MOInbox");
    if (inboxClass != NULL && dataDict && [dataDict allKeys].count > 0) {
        
        NSString* cid = [dataDict validObjectForKey:kInboxKeyCampaignID];
        if (cid && cid.length > 0) {
            [[inboxClass sharedInstance] trackInboxClickWithCampaignID:cid forAppID:appID];
        }
        else{
            [MOLogger debug:@"Campaign ID is not present‼️" label:nil sdkConfig:nil];
        }
    }
}

-(void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo{
    NSString* appID = [MoEPluginUtils getAppID:campaignInfo];
    NSDictionary* dataDict = [MoEPluginUtils getDataDict:campaignInfo];
    
    Class   inboxClass   = nil;
    inboxClass = NSClassFromString(@"MoEngageInbox.MOInbox");
    id inbox = nil;
    
    if (dataDict && [dataDict allKeys].count > 0 && inboxClass != NULL) {
        inbox = [inboxClass sharedInstance];
        NSString* cid = [campaignInfo validObjectForKey:kInboxKeyCampaignID];
        if (cid && cid.length > 0 && inboxClass != NULL) {
            [inbox removeInboxMessageWithCampaignID:cid forAppID:appID];
        }
        else{
            [MOLogger debug:@"Campaign ID is not present‼️" label:nil sdkConfig:nil];
        }
    }
}

-(void)getUnreadMessageCount:(NSDictionary*)dict completionBlock:(void(^) (NSDictionary* inboxDataDict))completionBlock{
    NSString* appID = [MoEPluginUtils getAppID:dict];
    Class   inboxClass   = nil;
    inboxClass = NSClassFromString(@"MoEngageInbox.MOInbox");
    if (inboxClass != NULL) {
        [[inboxClass sharedInstance] getUnreadNotificationCountForAppID:appID withCompletionBlock:^(NSInteger unreadCount, MOAccountMeta * _Nullable accountMeta) {
            
            
            NSDictionary *accountMetaDict = @ {
            kAppID: appID
            };

            NSDictionary *dataDict =  @ {
                @"unClickedCount": [NSNumber numberWithInt:unreadCount]
            };
         
            NSDictionary* inboxPayloadDict = @ {
            kAccountMetaKey: accountMetaDict,
            kDataDictKey: dataDict
            };
            
            completionBlock(inboxPayloadDict);
        }];
    }
}

@end
