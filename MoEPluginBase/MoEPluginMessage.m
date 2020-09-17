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
        NSError *err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:updatedInfoDict options:0 error:&err];
        if (jsonData) {
            NSString *strPayload = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
            NSDictionary *dictPayload = @{
                @"payload" : strPayload
            };
            self.msgInfoDict = dictPayload;
        } else {
            NSLog(@"Error converting to dictionary to string %@", err.localizedDescription);
            self.msgInfoDict = @{};
        }
    }
    return self;
}
@end
