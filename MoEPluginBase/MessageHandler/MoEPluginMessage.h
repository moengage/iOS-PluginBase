//
//  MoEPluginMessage.h
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoEngage/MoEngage.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoEPluginMessage : NSObject
@property(nonatomic, strong) NSString* msgMethodName;
@property(nonatomic, strong) NSMutableDictionary* msgInfoDict;
@property(nonatomic, assign) BOOL dontQueue;

-(instancetype)initWithMethodName:(NSString*)methodName withInfoDict:(NSDictionary*)infoDict andAccountMeta:(MOAccountMeta* _Nullable) accountMeta;

@end

NS_ASSUME_NONNULL_END
