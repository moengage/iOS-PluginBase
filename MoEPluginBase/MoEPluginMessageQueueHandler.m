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
        if (self.messageQueue == nil) {
            self.messageQueue = [NSMutableArray array];
        }
        [self.messageQueue addObject:message];
    }
}

#pragma mark- Flush Message Queue

-(void)flushMessageQueue{
    self.isSDKInitialized = true;
    if (self.messageQueue != nil && self.messageQueue.count > 0) {
        for (MoEPluginMessage* message in [self.messageQueue copy]) {
            [self sendMessage:message];
        }
        [self.messageQueue removeAllObjects];
    }
}

#pragma mark- Send Message

-(void)sendMessage:(MoEPluginMessage*)message{
    SEL selector = @selector(sendMessageWithName:andPayload:);
    if ([MoEPluginBridge sharedInstance].bridgeDelegate != nil && [[MoEPluginBridge sharedInstance].bridgeDelegate respondsToSelector:selector]) {
        [[MoEPluginBridge sharedInstance].bridgeDelegate sendMessageWithName:message.msgMethodName andPayload:message.msgInfoDict];
    }
}

@end
