//
//  MoEPluginUtils.h
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoEPluginUtils : NSObject
+ (BOOL)isSDKProxyEnabled;
+ (BOOL)isSDKVersionGreaterThan5;
+ (NSDate * __nullable)getDateForString:(NSString *)strDate;
+ (BOOL)isCurrentSDKVersionValid;
+ (BOOL)isValidString:(id)value;
+ (BOOL)isValidDictionary:(id)value;
+ (BOOL)isValidArray:(id)value;
+ (void)dispatchOnMainQueue:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
