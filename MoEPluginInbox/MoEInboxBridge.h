//
//  MoEInboxBridge.h
//  MoEPluginInbox
//
//  Created by Rakshitha on 14/12/21.
//

#import <MoEngageInbox/MoEngageInbox-Swift.h>


@interface MoEInboxBridge : NSObject

+ (instancetype)sharedInstance;

- (void)getInboxMessagesForAccount:(NSDictionary*)inboxDict withCompletionBlock: (void(^) (NSDictionary* inboxMessages))completionBlock;
- (void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo;
- (void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo;
- (void)getUnreadMessageCount:(NSDictionary*)inboxDict completionBlock:(void(^) (NSDictionary* inboxDataDict))completionBlock;

@end
