//
//  NSDictionary+Utility.h
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 09/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Utility)
-(NSInteger)getIntegerForKey:(NSString *)key;
-(NSString *)getStringForKey:(NSString *)key;
-(NSDate * __nullable)getDateForKey:(NSString *)key dateFormat:(NSString *)format;
-(BOOL)getBooleanForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
