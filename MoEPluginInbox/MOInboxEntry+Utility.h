//
//  MOInboxEntry+Utility.h
//  MoEPluginInbox
//
//  Created by Chengappa C D on 02/11/20.
//

#import <Foundation/Foundation.h>
#import <MoEPluginBase/MoEPluginBase.h>
@import MoEngageMessaging;

#if __has_include(<MoEngageInbox/MoEngageInbox-Swift.h>)
    #import <MoEngageInbox/MoEngageInbox-Swift.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MOInboxEntry (Utility)
-(NSDictionary*)getPluginDictionaryRepresentation;
@end

NS_ASSUME_NONNULL_END



