//
//  MoEInboxController.h
//  Pods
//
//  Created by Rakshitha on 20/12/21.
//

#import "MoEngage/MoEngage.h"

@interface MoEInboxController : NSObject 
-(void)getInboxMessagesForAccount:(NSDictionary*)accountMeta withCompletionBlock: (void(^) (NSDictionary* inboxMessages))completionBlock;
-(void)trackInboxClickForCampaign:(NSDictionary*)campaignInfo;
-(void)deleteInboxEntryForCampaign:(NSDictionary*)campaignInfo;
-(void)getUnreadMessageCount:(NSDictionary*)dict completionBlock:(void(^) (NSDictionary* inboxDataDict))completionBlock;
@end
