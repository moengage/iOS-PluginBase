//
//  MoEPluginMessage.h
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoEPluginMessage : NSObject
@property(nonatomic, strong) NSString* msgMethodName;
@property(nonatomic, strong) NSDictionary* msgInfoDict;
@property(nonatomic, assign) BOOL dontQueue;

-(instancetype)initWithMethodName:(NSString*)methodName andInfoDict:(NSDictionary*)infoDict;

@end

NS_ASSUME_NONNULL_END
