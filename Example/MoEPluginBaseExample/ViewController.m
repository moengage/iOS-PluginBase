//
//  ViewController.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 09/08/2020.
//  Copyright (c) 2020 Chengappa C D. All rights reserved.
//

#import "ViewController.h"
#import <MoEPluginBase/MoEPluginBase.h>
#import <MoEPluginInbox/MoEPluginInbox.h>
#import <MoEPluginGeofence/MoEPluginGeofence.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray* dataSourceArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSourceArray = @[@"Plugin Initialized",@"Set AppStatus",@"Track Event",@"Track User Attributes",@"Set Alias",@"Register For Push", @"Show InApp", @"Self Handled InApp", @"Set Context",@"Invalidate Context", @"Reset User", @"Opt-Out Tracking", @"Opt-In Tracking", @"Check Validity", @"Inbox - Get Messages", @"Inbox - Unread Count",@"Enable SDK",@"Disable SDK", @"Enable logs", @"Start Geofence Monitoring"];
    
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
            NSDictionary* appstatusDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                }
            };
            [[MoEPluginBridge sharedInstance] pluginInitialized: appstatusDict];
            
            NSDictionary* dict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @{
                    @"state": @1
                }
            };
            [[MoEPluginBridge sharedInstance]enableLogs:dict];
            
            appstatusDict = @{
               @"accountMeta": @{
                   @"appID":@"NBZ7V0U8Y3KODMQL3ZDEI4FM"
               }
           };
           [[MoEPluginBridge sharedInstance] pluginInitialized:appstatusDict];
        
            break;
        }
        case 1:{
            NSDictionary* appstatusDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @{
                    @"appStatus": @"INSTALL"
                    
                }
            };
            [[MoEPluginBridge sharedInstance] setAppStatus:appstatusDict];

             appstatusDict = @{
                @"accountMeta": @{
                    @"appID":@"NBZ7V0U8Y3KODMQL3ZDEI4FM"
                },
                @"data": @{
                    @"appStatus": @"UPDATE"
                    
                }
            };
            [[MoEPluginBridge sharedInstance] setAppStatus:appstatusDict];

            break;
        }
        case 2:{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSString* timeAttr = [dateFormatter stringFromDate:[NSDate date]];
            NSDictionary* trackEventDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @ {
                @"eventName": @"Product Purchased",
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
                }
            };
            [[MoEPluginBridge sharedInstance] trackEventWithPayload:trackEventDict];
            break;
        }
        case 3:{
            // 1. Unique ID Attribute
            NSDictionary* userAttrPayload1 = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @ {
                    @"attributeName":@"USER_ATTRIBUTE_UNIQUE_ID",
                    @"attributeValue":@"Unique ID",
                    @"type":@"general"
                }
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload1];
            
             userAttrPayload1 = @{
                @"accountMeta": @{
                    @"appID":@""
                },
                @"data": @ {
                    @"attributeName":@"USER_ATTRIBUTE_UNIQUE_ID",
                    @"attributeValue":@"New Unique id",
                    @"type":@"general"
                }
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload1];
            
            // 2. Custom Attribute
            NSDictionary* userAttrPayload2 = @{
                @"accountMeta": @{
                    @"appID":@"NBZ7V0U8Y3KODMQL3ZDEI4FM"
                },
                @"data": @ {
                    @"attributeName":@"Attr 1",
                    @"attributeValue":@23.45,
                    @"type":@"general"
                }
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload2];
            
            // 3. Timestamp Attribute
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSString* timeAttr = [dateFormatter stringFromDate:[NSDate date]];
            NSDictionary* userAttrPayload3 = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @ {
                    
                    @"attributeName":@"timestamp user attr",
                    @"attributeValue":timeAttr,
                    @"type":@"timestamp"
                }
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload3];
            
            // 4. Location Attribute
            NSDictionary* userAttrPayload4 = @{
                @"accountMeta": @{
                    @"appID":@"NBZ7V0U8Y3KODMQL3ZDEI4FM"
                },
                @"data": @ {
                    @"attributeName":@"location user attr",
                    @"type":@"location",
                    @"locationAttribute":@{
                        @"latitude": @20,
                        @"longitude": @23
                    }
                }
            };
            [[MoEPluginBridge sharedInstance] setUserAttributeWithPayload:userAttrPayload4];
            break;
        }
        case 4:{
            NSDictionary* aliasDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @ {
                    @"alias": @"alias ID"
                }
            };
            [[MoEPluginBridge sharedInstance] setAlias:aliasDict];
            break;
        }
        case 5:{
            [[MoEPluginBridge sharedInstance] registerForPush];
            break;
        }
        case 6:{
            NSDictionary* dict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                }
            };
            [[MoEPluginBridge sharedInstance] showInApp: dict];
            
            dict = @{
                @"accountMeta": @{
                    @"appID":@"NBZ7V0U8Y3KODMQL3ZDEI4FM"
                }
            };
            [[MoEPluginBridge sharedInstance] showInApp: dict];
            
            break;
        }
        case 7:{
            NSDictionary* dict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
            };
            [[MoEPluginBridge sharedInstance] getSelfHandledInApp:dict];
            break;
        }
        case 8:{
            NSDictionary* contextDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data":@ {
                    @"contexts": @[@"Home", @"Settings"]
                }
            };
            
            [[MoEPluginBridge sharedInstance] setInAppContexts:contextDict];
            break;
        }
        case 9:{
            NSDictionary* aliasDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                }
            };
            [[MoEPluginBridge sharedInstance] invalidateInAppContexts: aliasDict];
            break;
        }
        case 10:{
            NSDictionary* aliasDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                }
            };
            [[MoEPluginBridge sharedInstance] resetUser: aliasDict];
            break;
        }
        case 11:{
            NSDictionary* optOutDataDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @ {
                    @"type": @"data",
                    @"state": @1
                }
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutDataDict];
            break;
        }
        case 12:{
            NSDictionary* optOutDataDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @ {
                    @"type": @"data",
                    @"state": @0
                }
            };
            [[MoEPluginBridge sharedInstance] optOutTracking:optOutDataDict];
            
            break;
        }
        case 13:{
            [[MoEPluginBridge sharedInstance] isValidNativeDependencyIntegrated];
            break;
        }
        case 14:{
            NSDictionary* inboxDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                }
            };
            
            [[MoEInboxBridge sharedInstance] getInboxMessagesForAccount:inboxDict withCompletionBlock:^(NSDictionary *inboxMessages) {
                NSLog(@"inboxMessages %@", inboxMessages);
            }];
            
            inboxDict = @{
                @"accountMeta": @{
                    @"appID":@"NBZ7V0U8Y3KODMQL3ZDEI4FM"
                }
            };
            
            
            [[MoEInboxBridge sharedInstance] getInboxMessagesForAccount:inboxDict withCompletionBlock:^(NSDictionary *inboxMessages) {
                NSLog(@"inboxMessages %@", inboxMessages);
            }];
        }
            break;
        case 15:{
            NSDictionary* aliasDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                }
            };
            [[MoEInboxBridge sharedInstance] getUnreadMessageCount:aliasDict completionBlock:^(NSDictionary *inboxDataDict) {
                NSLog(@"inboxMessages unread count %@", inboxDataDict);
            }];
            break;
        }
        case 16:{
            NSDictionary* enableSDKDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @{
                    @"isSdkEnabled": @1
                }
            };
            
            [[MoEPluginBridge sharedInstance] updateSDKState:enableSDKDict];
            break;
        }
        case 17:{
            NSDictionary* enableSDKDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @{
                    @"isSdkEnabled": @0
                }
            };
            
            [[MoEPluginBridge sharedInstance] updateSDKState:enableSDKDict];
            break;
        }
            
        case 18:{
            NSDictionary* enableLogsDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                },
                @"data": @{
                    @"state": @1
                }
            };
            
            [[MoEPluginBridge sharedInstance]enableLogs:enableLogsDict];
            
            enableLogsDict = @{
                @"accountMeta": @{
                    @"appID":@"NBZ7V0U8Y3KODMQL3ZDEI4FM"
                },
                @"data": @{
                    @"state": @1
                }
            };
            
            [[MoEPluginBridge sharedInstance]enableLogs:enableLogsDict];
            
            break;
        }
            
        case 19:{
            NSDictionary* aliasDict = @{
                @"accountMeta": @{
                    @"appID":@"DAO6UGZ73D9RTK8B5W96TPYN"
                }
            };
            
            [[MoEGeofenceBridge sharedInstance] startGeofenceMonitoring:aliasDict];
            break;
        }
            
        default:
            break;
    }
}

@end
