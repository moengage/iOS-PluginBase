//
//  MOInAppCampaign+Utility.m
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 08/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MOInAppCampaign+Utility.h"
#import <objc/runtime.h>
#import "MoEPluginConstants.h"

@implementation MOInAppCampaign (Utility)

- (NSDictionary *)dictionaryRepresentation {
    
    return @{
        @"campaignName" : self.campaign_name,
        @"campaignId" : self.campaign_id,
        @"campaignContext": self.campaign_context,
    };
}


@end
