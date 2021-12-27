//
//  MoEInboxController.m
//  MoEPluginInbox
//
//  Created by Rakshitha on 20/12/21.
//

#import <Foundation/Foundation.h>
#import "MoEInboxController.h"
#import <MoEPluginBase/MoEPluginBase.h>
#import "MoEPluginInbox/MoEPluginInbox.h"
#import "MOInboxEntry+Utility.h"
#import <MoEngageObjCUtils/MoEngageObjCUtils.h>
#import <MoEngageInbox/MoEngageInbox-Swift.h>

@implementation MoEInboxController

- (void)getInboxMessagesForAccount:(NSDictionary*)accountMeta withCompletionBlock:(void(^)(NSDictionary* inboxMessages))completionBlock{
    NSString* appID = [MoEPluginUtils getAppID:accountMeta];
    
    if (completionBlock == nil || appID.length <= 0) {
        return;
    }
    
    [[MOInbox sharedInstance] getInboxMessagesForAppID:appID withCompletionBlock:^(NSArray<MOInboxEntry *> * _Nonnull inboxMessages, MOAccountMeta * _Nullable accountMeta) {
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

- (void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo{
    NSString* appID = [MoEPluginUtils getAppID:campaignInfo];
    NSDictionary* dataDict = [MoEPluginUtils getDataDict:campaignInfo];
    
    if (dataDict && [dataDict allKeys].count > 0 && appID != nil && appID.length > 0) {
        
        NSString* cid = [dataDict validObjectForKey:kInboxKeyCampaignID];
        if (cid && cid.length > 0) {
            [[MOInbox sharedInstance] trackInboxClickWithCampaignID:cid forAppID:appID];
        }
        else{
            [MOLogger debug:@"Campaign ID is not present‼️" label:kLoggerPluginBase sdkConfig:nil];
        }
    }
}

- (void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo{
    NSString* appID = [MoEPluginUtils getAppID:campaignInfo];
    NSDictionary* dataDict = [MoEPluginUtils getDataDict:campaignInfo];
    
    if (dataDict && [dataDict allKeys].count > 0 && appID != nil && appID.length > 0) {
        NSString* cid = [campaignInfo validObjectForKey:kInboxKeyCampaignID];
        if (cid && cid.length > 0) {
            [[MOInbox sharedInstance] removeInboxMessageWithCampaignID:cid forAppID:appID];
        }
        else{
            [MOLogger debug:@"Campaign ID is not present‼️" label:kLoggerPluginBase sdkConfig:nil];
        }
    }
}

- (void)getUnreadMessageCount:(NSDictionary*)dict completionBlock:(void(^)(NSDictionary* inboxDataDict))completionBlock{
    NSString* appID = [MoEPluginUtils getAppID:dict];
    if (appID.length > 0) {
        [[MOInbox sharedInstance] getUnreadNotificationCountForAppID:appID withCompletionBlock:^(NSInteger unreadCount, MOAccountMeta * _Nullable accountMeta) {
            
            NSDictionary *accountMetaDict = @ {
            kAppID: appID
            };
            
            NSDictionary *dataDict =  @ {
                @"unClickedCount": [NSNumber numberWithInteger:unreadCount]
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
