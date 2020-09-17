//
//  MOProperties+Utility.m
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 11/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MOProperties+Utility.h"
#import "NSDictionary+Utility.h"
#import "MoEPluginConstants.h"
#import "MoEPluginUtils.h"


@implementation MOProperties (Utility)

-(instancetype)initWithTrackEventsDictionary:(NSDictionary*)dictEvents {
    
    NSDictionary *generalAttributes = [dictEvents objectForKey:@"generalAttributes"];
    
    if (generalAttributes && [generalAttributes isKindOfClass:[NSDictionary class]]) {
        self = [self initWithAttributes: [generalAttributes mutableCopy]];
    } else {
        self = [super init];
    }
    
    if (self) {
        
        if ([dictEvents isKindOfClass:[NSDictionary class]]) {
            [self addLocationAttributeFromDictionary:[dictEvents objectForKey:@"locationAttributes"]];
            [self addDateAttributeFromDictionary:[dictEvents objectForKey:@"dateTimeAttributes"]];
            [self modifyEventInteractionFromDictionary:dictEvents];
        }
    }
    return self;
}

-(void)addLocationAttributeFromDictionary:(NSDictionary*)locationAttributes {
    
    if (locationAttributes && [locationAttributes isKindOfClass:[NSDictionary class]]) {
        for(id key in locationAttributes) {
            NSString *strKey = [NSString stringWithFormat:@"%@", key];
            if (strKey) {
                NSDictionary *value = [locationAttributes objectForKey:key];
                if (value && [value isKindOfClass:[NSDictionary class]]) {
                    NSNumber *latitude = [value objectForKey:@"latitude"];
                    NSNumber *longitude = [value objectForKey:@"longitude"];
                    if (latitude && longitude) {
                        MOGeoLocation *location = [[MOGeoLocation alloc] initWithLatitude:[latitude doubleValue] andLongitude:[longitude doubleValue]];
                        [self addLocationAttribute:location withName:key];
                    }
                }
            }
        }
    }
}

-(void)addDateAttributeFromDictionary:(NSDictionary*)dateAttributes {
    if (dateAttributes && [dateAttributes isKindOfClass:[NSDictionary class]]) {
        for(id key in dateAttributes) {
            NSString *strKey = [NSString stringWithFormat:@"%@", key];
            if (strKey) {
                NSString *value = [dateAttributes getStringForKey:key];
                if (value) {
                    NSDate *date = [MoEPluginUtils getDateForString:value];
                    if (date) {
                        [self addDateAttribute:date withName:strKey];
                    }
                }
            }
        }
    }
}

- (void)modifyEventInteractionFromDictionary:(NSDictionary*)dictEvent {
    
    BOOL nonInteractive = [dictEvent getBooleanForKey:@"isNonInteractive"];
    if (nonInteractive) {
        [self setNonInteractive];
    }
}

@end
