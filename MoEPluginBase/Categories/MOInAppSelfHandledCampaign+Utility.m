//
//  MOInAppSelfHandledCampaign+Utility.m
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 09/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MOInAppSelfHandledCampaign+Utility.h"
#import "NSDictionary+Utility.h"
#import "MoEPluginConstants.h"
#import "MoEPluginUtils.h"



@implementation MOInAppSelfHandledCampaign (Utility)

- (instancetype)initWithCampaignInfoDictionary:(NSDictionary *)dictInfo {
    
    self = [super init];
    if (self && dictInfo) {
        self.campaign_id = [dictInfo getStringForKey:@"campaignId"];
        self.campaign_name = [dictInfo getStringForKey:@"campaignName"];
        NSDate *date = [dictInfo getDateForKey:@"expiryTime" dateFormat: kISODateFormat1];
        if (date == NULL) {
            date = [dictInfo getDateForKey:@"expiryTime" dateFormat: kISODateFormat2];
        }
        self.expiry_time = date;
        
        NSDictionary* selfHandledDict = [dictInfo validObjectForKey:@"selfHandled"];
        if (selfHandledDict) {
            self.autoDismissInterval = [selfHandledDict getIntegerForKey:@"dismissInterval"];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dict = [@{
        @"campaignName" : self.campaign_name,
        @"campaignId" : self.campaign_id,

    } mutableCopy];
    
    NSMutableDictionary *dictSelfHandle = [[NSMutableDictionary alloc] init];
    
    if ([MoEPluginUtils isValidString:self.campaignContent]) {
        [dictSelfHandle setObject: self.campaignContent forKey:@"payload"];
    }
    if (self.autoDismissInterval > -1) {
        [dictSelfHandle setObject: [NSNumber numberWithInteger:self.autoDismissInterval] forKey:@"dismissInterval"];
    }
    if (dictSelfHandle.count > 0) {
        [dict setObject:dictSelfHandle forKey: @"selfHandled"];
    }
    return dict;
}

@end
