//
//  NSDictionary+Utility.m
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 09/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//
#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

-(NSInteger)getIntegerForKey:(NSString *)key {
    
    NSString *value = [self stringForkey: key];
    if (value == NULL) {
        return -1;
    }
    return [value integerValue];
}

-(NSString *)getStringForKey:(NSString *)key {
    
    NSString *value = [self stringForkey: key];
    if (value == NULL) {
        return @"";
    }
    return value;
}

-(NSDate * __nullable)getDateForKey:(NSString *)key dateFormat:(NSString *)format {
    
    if (format == NULL || format.length == 0) {
        return NULL;
    }
    NSString *value = [self stringForkey:key];
    if (value == NULL) {
        return NULL;
    }
    NSString *strDate = [NSString stringWithFormat:@"%@", value];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:strDate];
}

-(BOOL)getBooleanForKey:(NSString *)key {
   
    NSString *value = [self stringForkey: key];
    if (value == NULL) {
        return NO;
    }
    return [value boolValue];
}

- (NSString * __nullable)stringForkey:(NSString *)key {
    if (key == NULL || key.length == 0) {
        return NULL;
    }
    id value = [self objectForKey:key];
    if (value) {
        return [NSString stringWithFormat:@"%@", value];
    }
    return NULL;
}

@end
