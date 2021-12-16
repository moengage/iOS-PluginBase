//
//  MoEInboxBridge.h
//  MoEPluginInbox
//
//  Created by Rakshitha on 14/12/21.
//

#if __has_include(<MoEngageInbox/MoEngageInbox-Swift.h>)
#import <MoEngageInbox/MoEngageInbox-Swift.h>
#endif


@interface MoEInboxBridge : NSObject
+(instancetype)sharedInstance;

-(void)getInboxMessagesForAccount:(NSDictionary*)accountMeta withCompletionBlock: (void(^) (NSDictionary* inboxMessages))completionBlock;
-(void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo;
-(void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo;
-(void)getUnreadMessageCount:(NSDictionary*)dict completionBlock:(void(^) (NSDictionary* inboxDataDict))completionBlock;
@end
