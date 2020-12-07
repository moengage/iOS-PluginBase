//
//  MoEPluginMessageQueueHandler.h
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MoEPluginBase/MoEPluginMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoEPluginMessageQueueHandler : NSObject
@property(nonatomic,assign) BOOL isSDKInitialized;
+(instancetype)sharedInstance;

-(void)queueMessage:(MoEPluginMessage*)message;
-(void)flushMessageQueue;
@end

NS_ASSUME_NONNULL_END
