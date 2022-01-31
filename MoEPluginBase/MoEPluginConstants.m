//
//  MoEPluginConstants.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 14/02/20.
//  Copyright © 2020 MoEngage. All rights reserved.
//

#import "MoEPluginConstants.h"

NSString* const kEventNamePushTokenGenerated              = @"MoEPushTokenGenerated";
NSString* const kEventNamePushClicked                     = @"MoEPushClicked";
NSString* const kEventNameInAppCampaignShown              = @"MoEInAppCampaignShown";
NSString* const kEventNameInAppCampaignClicked            = @"MoEInAppCampaignClicked";
NSString* const kEventNameInAppCampaignDismissed          = @"MoEInAppCampaignDismissed";
NSString* const kEventNameInAppCampaignCustomAction       = @"MoEInAppCampaignCustomAction";
NSString* const kEventNameInAppSelfHandledCampaign        = @"MoEInAppCampaignSelfHandled";

NSString* const kPlistKeyAppDelegateProxyStatus = @"MoEngageAppDelegateProxyEnabled";


NSString* const kISODateFormat1 = @"yyyy-MM-dd'T'HH:mm:ss'Z";
NSString* const kISODateFormat2 = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

// Version format: Major.Minor.Patch
NSString* const kMinSDKVersionSupported = @"7.2.0";
NSString* const kMaxSDKVersionSupported = @"7.3.0";

// Inbox Keys
NSString* const kInboxKeyID             = @"id";
NSString* const kInboxKeyCampaignID     = @"campaignId";
NSString* const kInboxKeyTag            = @"tag";
NSString* const kInboxKeyIsClicked      = @"isClicked";
NSString* const kInboxKeyReceivedTime   = @"receivedTime";
NSString* const kInboxKeyExpiry         = @"expiry";
NSString* const kInboxKeyPayload        = @"payload";
NSString* const kInboxKeyText           = @"text";
NSString* const kInboxKeyMedia          = @"media";
NSString* const kInboxKeyAction         = @"action";

NSString* const kInboxKeyTextTitle      = @"title";
NSString* const kInboxKeyTextSubTitle   = @"subtitle";
NSString* const kInboxKeyTextMessage    = @"message";

NSString* const kInboxKeyMediaType      = @"type";
NSString* const kInboxKeyMediaURL       = @"url";

NSString* const kInboxKeyActionType     = @"actionType";
NSString* const kInboxKeyActionNavType  = @"navigationType";
NSString* const kInboxKeyActionValue    = @"value";
NSString* const kInboxKeyActionKVPair   = @"kvPair";

NSString* const kInboxValActionTypeNav  = @"navigation";

NSString* const kInboxValNavActionDeepLink      = @"deepLink";
NSString* const kInboxValNavActionScreenName    = @"screenName";
NSString* const kInboxValNavActionRichLanding   = @"richLanding";

NSString* const kInboxValMediaTypeImage   = @"image";
NSString* const kInboxValMediaTypeAudio   = @"audio";
NSString* const kInboxValMediaTypeVideo   = @"video";

NSString* const kTrackEventName         = @"eventName";
NSString* const kEventAttributes        = @"eventAttributes";
NSString* const kIsNonInteractive       = @"isNonInteractive";
