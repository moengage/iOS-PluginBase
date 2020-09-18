//
//  MOProperties+Utility.h
//  MoEPluginBase
//
//  Created by Abhishek Banerjee on 11/06/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//


#import <MOAnalytics/MOAnalytics.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOProperties (Utility)

-(instancetype)initWithTrackEventsDictionary:(NSDictionary*)dictEvents;
-(void)modifyEventInteractionFromDictionary:(NSDictionary*)dictEvent;
@end

NS_ASSUME_NONNULL_END
