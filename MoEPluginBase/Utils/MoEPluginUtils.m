//
//  MOReactUtils.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPluginUtils.h"
#import "MoEPluginConstants.h"
#import <MoEngage/MoEngage.h>

@implementation MoEPluginUtils

+(BOOL)isSDKProxyEnabled{
    // AppDelegate in core SDK is from version 5.0.0
    if (![self isSDKVersionGreaterThan5]) {
        return false;
    }
    
    // Check SDK Proxy key
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    if ( [infoDict objectForKey:kPlistKeyAppDelegateProxyStatus] != nil && [infoDict objectForKey:kPlistKeyAppDelegateProxyStatus] != [NSNull null]) {
        return [[infoDict objectForKey:kPlistKeyAppDelegateProxyStatus] boolValue];
    }
    else{
        return true;
    }
}

+(BOOL)isSDKVersionGreaterThan5{
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[MoEngage class]] infoDictionary];
    NSString *sdk_version_str = [infoDictionary valueForKey:@"CFBundleShortVersionString"];
    if(sdk_version_str != nil){
        NSArray* version_arr = [sdk_version_str componentsSeparatedByString:@"."];
        NSString* major_version_str = version_arr[0];
        NSInteger major_version = [major_version_str integerValue];
        
        if(major_version < 5){
            return false;
        }
    }
    return true;
}

// Check if version >= Min Version && version < Max Version
+(BOOL)isCurrentSDKVersionValid {
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[MoEngage class]] infoDictionary];
    NSString *sdkVersionStr = [infoDictionary valueForKey:@"CFBundleShortVersionString"];
    if(sdkVersionStr != nil){
        long currSdkVersion = [self getNumberRepresentationForVersion:sdkVersionStr];
        long minSdkVersion  = [self getNumberRepresentationForVersion:kMinSDKVersionSupported];
        long maxSdkVersion  = [self getNumberRepresentationForVersion:kMaxSDKVersionSupported];
        
        if (currSdkVersion >= minSdkVersion && currSdkVersion < maxSdkVersion) {
            return true;
        }
        return false;
    }
    else{
        NSLog(@"MoEngage: Plugin Bridge - Native Dependencies not integrated");
        return false;
    }
}


+(long)getNumberRepresentationForVersion:(NSString*)versionStr{
    // Version format: Major.Minor.Patch
    // eg: 99.99.999
    // Number representation  = major * 100000 + minor * 1000 + patch
    // major = num / 100000 , minor = (num % 100000) / 1000 , patch = (num % 1000)
    long versionNumRep = 0;
    if (versionStr) {
        NSArray* versionStrArr = [versionStr componentsSeparatedByString:@"."];
        long major = 0, minor = 0, patch = 0;
        
        if (versionStrArr.count > 0) {
            major = [versionStrArr[0] integerValue];
        }
        if (versionStrArr.count > 1) {
            minor = [versionStrArr[1] integerValue];
        }
        if (versionStrArr.count > 2) {
            patch = [versionStrArr[2] integerValue];
        }
        versionNumRep = (major * 100000) + (minor * 1000) + patch;
    }
    return versionNumRep;
}

+(NSDate * __nullable)getDateForString:(NSString *)strDate {
    if (strDate == NULL || strDate.length == 0) {
        return NULL;
    }
    NSDate *date = [MODateUtils getDateForString:strDate withFormat:kISODateFormat1 andForGMTTimeZone:NO];
    if (date == NULL) {
        date = [MODateUtils getDateForString:strDate withFormat:kISODateFormat2 andForGMTTimeZone:NO];
    }
    return date;
}

+ (BOOL)isValidString:(id)value {
    if (value && [value isKindOfClass: [NSString class]]) {
        NSString *string = (NSString *)value;
        return string.length != 0;
    }
    return NO;
}

+ (BOOL)isValidDictionary:(id)value {
    if (value && [value isKindOfClass: [NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)value;
        return dict.count != 0;
    }
    return NO;
}

+ (BOOL)isValidArray:(id)value {
    if (value && [value isKindOfClass: [NSArray class]]) {
        NSArray *array = (NSArray *)value;
        return array.count != 0;
    }
    return NO;
}

+ (void)dispatchOnMainQueue:(dispatch_block_t)block {
    if ([NSThread currentThread].isMainThread) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+(NSString *)jsonStringFromDict:(NSDictionary *)dict {
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    if(err != nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(NSDictionary*)getDataDict:(NSDictionary *)dict {
    return [dict valueForKey: kDataDictKey];
}

+(NSString* __nullable)getAppID:(NSDictionary *)dict {
    NSDictionary* accountMetaDict = [dict valueForKey:kAccountMetaKey];
    NSString* appID = [accountMetaDict valueForKey:kAppID];
    
    if (appID == nil || appID.length == 0) {
        appID = [[MoEngage sharedInstance] getDefaultSDKConfiguration].moeAppID;
    }
    
    return appID;
}
@end
