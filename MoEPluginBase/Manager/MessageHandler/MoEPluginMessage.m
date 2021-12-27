//
//  MoEPluginMessage.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPluginMessage.h"
#import "MoEPluginConstants.h"
#import "MoEPluginUtils.h"
#import "MoEngage/MoEngage.h"

@implementation MoEPluginMessage

- (instancetype)initWithMethodName:(NSString*)methodName withInfoDict:(NSDictionary*)infoDict andAccountMeta:(MOAccountMeta*)accountMeta {
    self = [super init];
    if (self) {
        self.msgMethodName = methodName;
        self.msgInfoDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionary];
        dataDict[kPlatform] = kiOS;
        if (infoDict) {
            [dataDict addEntriesFromDictionary:infoDict];
        }
        
        
        [self.msgInfoDict setValue:dataDict forKey:kDataDictKey];
        if (accountMeta.appID != nil ) {
            NSDictionary* accountMetaDict = @ {
            kAppID: accountMeta.appID
            };
            
            [self.msgInfoDict setValue:accountMetaDict forKey:kAccountMetaKey];
        }
    }
    return self;
}
@end
