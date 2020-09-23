//
//  MoEPluginMessage.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPluginMessage.h"

@implementation MoEPluginMessage

-(instancetype)initWithMethodName:(NSString*)methodName andInfoDict:(NSDictionary*)infoDict {
    self = [super init];
    if (self) {
        self.msgMethodName = methodName;
        NSMutableDictionary* updatedInfoDict = [NSMutableDictionary dictionary];
        updatedInfoDict[@"platform"] = @"ios";
        if (infoDict) {
            [updatedInfoDict addEntriesFromDictionary:infoDict];
        }
        NSDictionary *dictPayload = @{
            @"payload" : updatedInfoDict
        };
        self.msgInfoDict = dictPayload;
    }
    return self;
}
@end
