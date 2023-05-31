//
//  ViewController.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "ViewController.h"
@import MoEngageSegmentPluginBase;
@import MoEngageSDK;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray* dataSourceArray;
@property(nonatomic, strong) NSString* defaultAppID;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.defaultAppID = @"YOUR APP ID";
    [[MoEngageCoreIntegrator sharedInstance] enableSDKForSegmentWithInstanceID: self.defaultAppID];
    self.dataSourceArray = @[@"Track Event",@"Track User Attributes",@"Set Alias", @"Reset User",@"Track AnonymousId"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            NSString* timeAttr = [dateFormatter stringFromDate:[NSDate date]];
            NSDictionary* trackEventDict = @{
                @"accountMeta": @{
                    @"appId": self.defaultAppID
                },
                @"data": @{
                    @"event": @"Mobile",
                    @"properties": @{
                         @"id": @321,
                           @"name": @"iPhone",
                           @"purchaseTime": @"2020-06-10T12:42:10Z",
                           @"billAmount": @12312.12,
                           @"userDetails": @{
                               @"userName": @"moengage",
                               @"email": @"moengage@test.com",
                               @"phone": @"1234567890",
                               @"gender": @"male"
                           },
                }
                }
            };
            [[MoEngageSegmentPluginBridge sharedInstance] trackEvent: trackEventDict];
            break;
        }
        case 1:{
            // 1. Unique ID Attribute
            NSDictionary* userAttrPayload1 = @{
                @"accountMeta": @{
                    @"appId": self.defaultAppID
                },
                @"data": @{
                    @"traits": @{
                        @"USER_ATTRIBUTE_UNIQUE_ID": @"123456",
                        @"USER_ATTRIBUTE_SEGMENT_ID": @"45666",
                        @"USER_ATTRIBUTE_USER_BDAY": @"2020-06-10T12:42:10Z",
                        @"USER_ATTRIBUTE_USER_EMAIL": @"email",
                        @"USER_ATTRIBUTE_USER_FIRST_NAME": @"fname",
                        @"USER_ATTRIBUTE_USER_LAST_NAME": @"lname",
                        @"USER_ATTRIBUTE_USER_MOBILE": @"99887777",
                        @"USER_ATTRIBUTE_USER_GENDER": @"male",
                        @"address": @{
                            @"street": @"",
                            @"city": @"",
                            @"country": @"",
                            @"state": @"",
                            @"postalCode": @""
                        },
                        @"location": @{
                            @"latitude": @24.0,
                            @"longitude": @43.0
                        }
                    }
                }
            };
            [[MoEngageSegmentPluginBridge sharedInstance] setUserAttribute:userAttrPayload1];
        }
        case 2:{
            NSDictionary* aliasDict = @{
                @"accountMeta": @{
                    @"appId": self.defaultAppID
                },
                @"data": @{
                    @"alias": @"alias ID"
                }
            };
            [[MoEngageSegmentPluginBridge sharedInstance] setAlias:aliasDict];
            break;
        }
        case 3:{
            NSDictionary* resetDict = @{
                @"accountMeta": @{
                    @"appId": self.defaultAppID
                }
            };
            [[MoEngageSegmentPluginBridge sharedInstance] resetUser:resetDict];
            break;
        }
        case 4:{
            NSDictionary* idPayload = @{
                @"accountMeta": @{
                    @"appId": self.defaultAppID
                },
                @"data": @{
                    @"anonymousId": @"12344"
                }
            };
            [[MoEngageSegmentPluginBridge sharedInstance] trackAnonymousId:idPayload];
            break;
        }
        default:
            break;
    }
}

@end
