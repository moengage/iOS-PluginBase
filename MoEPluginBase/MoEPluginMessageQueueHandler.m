//
//  MOReactMessageQueueHandler.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPluginMessageQueueHandler.h"
#import "MoEPluginBridge.h"

@interface MoEPluginMessageQueueHandler()
@property(nonatomic,strong) NSMutableArray* messageQueue;
@property (nonatomic, strong) dispatch_queue_t syncQueue;
@end

@implementation MoEPluginMessageQueueHandler

#pragma mark- Initialization

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MoEPluginMessageQueueHandler *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MoEPluginMessageQueueHandler alloc] init];
    });
    return instance;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        self.syncQueue = dispatch_queue_create("com.moengage.pluginBase.messageQueue", DISPATCH_QUEUE_SERIAL);
        self.messageQueue = [NSMutableArray array];
    }
    return self;
}

#pragma mark- Queue Message

-(void)queueMessage:(MoEPluginMessage*)message{
    if (message == nil || message.msgMethodName == nil) {
        return;
    }
    
    if (self.isSDKInitialized || message.dontQueue) {
        [self sendMessage:message];
    }
    else{
        dispatch_async(self.syncQueue, ^{
            if (self.messageQueue == nil) {
                self.messageQueue = [NSMutableArray array];
            }
            [self.messageQueue addObject:message];
        });
    }
}

#pragma mark- Flush Message Queue

-(void)flushMessageQueue{
    self.isSDKInitialized = true;
    dispatch_async(self.syncQueue, ^{
        if (self.messageQueue != nil && self.messageQueue.count > 0) {
            for (MoEPluginMessage* message in self.messageQueue) {
                [self sendMessage:message];
            }
            [self.messageQueue removeAllObjects];
        }
    });
}

#pragma mark- Send Message

-(void)sendMessage:(MoEPluginMessage*)message{
    SEL selector = @selector(sendMessageWithName:andPayload:);
    if ([MoEPluginBridge sharedInstance].bridgeDelegate != nil && [[MoEPluginBridge sharedInstance].bridgeDelegate respondsToSelector:selector]) {
        [[MoEPluginBridge sharedInstance].bridgeDelegate sendMessageWithName:message.msgMethodName andPayload:message.msgInfoDict];
    }
}

@end
