//
//  ViewController.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "ViewController.h"
#import <MoEPluginBase/MoEPluginBase.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray* dataSourceArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSourceArray = @[@"Plugin Initialized",@"Set AppStatus",@"Track Event",@"Track User Attributes",@"Set Alias",@"Register For Push", @"Show InApp", @"Self Handled InApp", @"Set Context",@"Invalidate Context", @"Reset User", @"Opt-Out Tracking", @"Opt-In Tracking", @"Check Validity", @"Inbox - Get Messages", @"Inbox - Unread Count",@"Enable SDK",@"Disable SDK", @"Update SDK Config"];
    
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
            [[MoEPluginBridge sharedInstance] pluginInitialized];
            break;
        }
        case 1:{
            NSDictionary* appstatusDict = @{
                @"appStatus": @"INSTALL"
            };
            [[MoEPluginBridge sharedInstance] setAppStatus:appstatusDict];
            break;
        }
        case 2:{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSString* timeAttr = [dateFormatter stringFromDate:[NSDate date]];
            NSDictionary* trackEventDict = @{
                @"eventName": @"Test Event Name",
                @"eventAttributes": @{
                        @"generalAttributes": @{
                                @"StringAttr": @"Hello MoEngage!!",
                                @"NumDoubleAttribute" : @123444.7877,
                                @"NumIntAttribute" : @1234,
                                @"boolAttribute" : @1
                        },
                        @"locationAttributes": @{
                                @"LocationAttr": @{
                                        @"latitude": @12.34,
                                        @"longitude": @13.23
                                }
                        },
                        @"dateTimeAttributes": @{
                                @"TimeAttr": timeAttr
                        }
                },
                @"isNonInteractive": @1
            };
            [[MoEPluginBridge sharedInstance] trackEventWithPayload:trackEventDict];
            break;
        }
        case 3:{
            // 1. Unique ID Attribute
            NSDictionary* userAttrPayload1 = @{
                @"attributeName":@"USER_ATTRIBUTE_UNIQUE_ID",
                @"attributeValue":@"Unique ID",
                @"type":@"general"
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload1];
            
            // 2. Custom Attribute
            NSDictionary* userAttrPayload2 = @{
                @"attributeName":@"Attr 1",
                @"attributeValue":@23.45,
                @"type":@"general"
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload2];
            
            // 3. Timestamp Attribute
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSString* timeAttr = [dateFormatter stringFromDate:[NSDate date]];
            NSDictionary* userAttrPayload3 = @{
                @"attributeName":@"timestamp user attr",
                @"attributeValue":timeAttr,
                @"type":@"timestamp"
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload3];
            
            // 4. Location Attribute
            NSDictionary* userAttrPayload4 = @{
                @"attributeName":@"location user attr",
                @"type":@"location",
                @"locationAttribute":@{
                        @"latitude": @23.23,
                        @"longitude": @43.34
                }
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload4];
            break;
        }
        case 4:{
            NSDictionary* aliasDict = @{
              @"alias": @"alias ID"
            };
            [[MoEPluginBridge sharedInstance] setAlias:aliasDict];
            break;
        }
        case 5:{
            [[MoEPluginBridge sharedInstance] registerForPush];
            break;
        }
        case 6:{
            [[MoEPluginBridge sharedInstance] showInApp];
            break;
        }
        case 7:{
            [[MoEPluginBridge sharedInstance] getSelfHandledInApp];
            break;
        }
        case 8:{
            NSDictionary* contextDict = @{
              @"contexts": @[@"Home", @"Settings"]
            };
            
            [[MoEPluginBridge sharedInstance] setInAppContexts:contextDict];
            break;
        }
        case 9:{
            [[MoEPluginBridge sharedInstance] invalidateInAppContexts];
            break;
        }
        case 10:{
            [[MoEPluginBridge sharedInstance] resetUser];
            break;
        }
        case 11:{
            NSDictionary* optOutDataDict = @{
              @"type": @"data",
              @"state": @1
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutDataDict];
            
            NSDictionary* optOutPushDict = @{
              @"type": @"push",
              @"state": @1
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutPushDict];
            
            NSDictionary* optOutInAppDict = @{
              @"type": @"inapp",
              @"state": @1
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutInAppDict];
            break;
        }
        case 12:{
            NSDictionary* optOutDataDict = @{
              @"type": @"data",
              @"state": @0
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutDataDict];
            
            NSDictionary* optOutPushDict = @{
              @"type": @"push",
              @"state": @0
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutPushDict];
            
            NSDictionary* optOutInAppDict = @{
              @"type": @"inapp",
              @"state": @0
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutInAppDict];
            break;
        }
        case 13:{
            [[MoEPluginBridge sharedInstance] isValidNativeDependencyIntegrated];
            break;
        }
        case 14:{
            [[MoEPluginBridge sharedInstance] getInboxMessagesWithCompletionBlock:^(NSDictionary *inboxMessages) {
                            NSLog(@"Messages : %@",inboxMessages);
            }];
        }
        case 15:{
            NSLog(@"Unread Count : %ld",(long)[[MoEPluginBridge sharedInstance] getUnreadMessageCount]);
            break;
        }
        case 16:{
            [[MoEPluginBridge sharedInstance] updateSDKState:@{@"isSdkEnabled": @1}];
            break;
        }
        case 17:{
            [[MoEPluginBridge sharedInstance] updateSDKState:@{@"isSdkEnabled": @0}];
            break;
        }
        case 18: {
            MOSDKConfig *config = [[MoEPluginBridge sharedInstance] getDefaultSDKConfig];
            config.moeDataCenter = DATA_CENTER_03;
            config.optOutPushNotification = TRUE;
            [[MoEPluginBridge sharedInstance] updateSDKConfig: config];
        }
        default:
            break;
    }
}

@end
