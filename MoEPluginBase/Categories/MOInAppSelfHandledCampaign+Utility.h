//
//  MOInAppSelfHandledCampaign+Utility.h
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 09/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//


#import <MOInApp/MOInApp.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOInAppSelfHandledCampaign (Utility)
- (instancetype)initWithCampaignInfoDictionary:(NSDictionary *)dictInfo;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
