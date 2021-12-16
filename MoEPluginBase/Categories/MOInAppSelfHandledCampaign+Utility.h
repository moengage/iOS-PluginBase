//
//  MOInAppSelfHandledCampaign+Utility.h
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 09/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//


#import <MoEngageInApps/MOInApp.h>
#import "MoEngage/MoEngage.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOInAppSelfHandledCampaign (Utility)
- (instancetype)initWithCampaignInfoDictionary:(NSDictionary *)dictInfo;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
