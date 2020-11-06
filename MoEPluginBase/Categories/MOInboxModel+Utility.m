//
//  MOInboxData+Utility.m
//  MoEPluginBase
//
//  Created by Chengappa C D on 02/11/20.
//

#import "MOInboxModel+Utility.h"
#import "MoEPluginConstants.h"

@implementation MOInboxModel (Utility)
-(NSDictionary*)getPluginDictionaryRepresentation{
    NSMutableDictionary* pluginDict = [NSMutableDictionary dictionary];
    //Campaign ID
    if (self.campaignID) {
        pluginDict[kInboxKeyCampaignID] = self.campaignID;
    }
    
    // IsClicked
    pluginDict[kInboxKeyIsClicked] = [NSNumber numberWithBool:self.isRead];
    
    // Received Time
    NSString* receivedDateStr = [MODateUtils getStringForDate:self.receivedDate withFormat:kMODateFormatISO8601MilliSec andForGMTTimeZone:true];
    if (receivedDateStr) {
        pluginDict[kInboxKeyReceivedTime] = receivedDateStr;
    }
    
    // Expiry Time
    NSString* expiryStr = [MODateUtils getStringForDate:self.inboxExpiryDate withFormat:kMODateFormatISO8601MilliSec andForGMTTimeZone:true];
    if (expiryStr) {
        pluginDict[kInboxKeyExpiry] = expiryStr;
    }
    
    // Payload
    if (self.notificationPayloadDict) {
        pluginDict[kInboxKeyPayload] = self.notificationPayloadDict;
    }
    
    // Text
    NSMutableDictionary* textDict = [self getPluginDictForTextContent];
    pluginDict[kInboxKeyText] = textDict;
    
    // Media
    NSMutableDictionary* mediaDict = [self getPluginDictForMediaContent];
    pluginDict[kInboxKeyMedia] = mediaDict;
    
    // Action
    NSMutableArray* actionsArray = [self getPluginActionsArray];
    pluginDict[kInboxKeyAction] = actionsArray;
    
    return pluginDict;
}

-(NSMutableDictionary*)getPluginDictForTextContent{
    NSMutableDictionary* textDict = [NSMutableDictionary dictionary];
    if (self.notificationTitle) {
        textDict[kInboxKeyTextTitle] = self.notificationTitle;
    }
    else{
        textDict[kInboxKeyTextTitle] = @"";
    }
    
    if (self.notificationSubTitle) {
        textDict[kInboxKeyTextSubTitle] = self.notificationSubTitle;
    }
    else{
        textDict[kInboxKeyTextSubTitle] = @"";
    }
    
    if (self.notificationBody) {
        textDict[kInboxKeyTextMessage] = self.notificationBody;
    }
    else{
        textDict[kInboxKeyTextMessage] = @"";
    }
    return textDict;
}

-(NSMutableDictionary*)getPluginDictForMediaContent{
    NSMutableDictionary* mediaDict = [NSMutableDictionary dictionary];
    if (self.notificationMediaURL && self.notificationMediaURL.length) {
        mediaDict[kInboxKeyMediaURL] = self.notificationMediaURL;
        if (self.notificationPayloadDict) {
            NSString* mediaType = [self.notificationPayloadDict validObjectForKeyPath:@"moengage.media-type"];
            if (!mediaType) {
                mediaType = kInboxValMediaTypeImage;
            }
            mediaDict[kInboxKeyMediaType] = mediaType;
        }
    }
    return mediaDict;
}

-(NSMutableArray*)getPluginActionsArray{
    NSMutableArray* actionsArray = [NSMutableArray array];
    if (self.deepLinkURL && self.deepLinkURL.length > 0) {
        NSMutableDictionary* deepLinkActionDict = [NSMutableDictionary dictionary];
        deepLinkActionDict[kInboxKeyActionType] = kInboxValActionTypeNav;
        deepLinkActionDict[kInboxKeyActionNavType] = kInboxValNavActionDeepLink;
        deepLinkActionDict[kInboxKeyActionValue] = self.deepLinkURL;
        deepLinkActionDict[kInboxKeyActionKVPair] = self.screenDataDict;
        
        [actionsArray addObject:deepLinkActionDict];
    }
    
    if (self.screenName && self.screenName.length > 0) {
        NSMutableDictionary* screenActionDict = [NSMutableDictionary dictionary];
        screenActionDict[kInboxKeyActionType] = kInboxValActionTypeNav;
        screenActionDict[kInboxKeyActionNavType] = kInboxValNavActionScreenName;
        screenActionDict[kInboxKeyActionValue] = self.screenName;
        screenActionDict[kInboxKeyActionKVPair] = self.screenDataDict;
        
        [actionsArray addObject:screenActionDict];
    }
    
    if (self.richLandingURL && self.richLandingURL.length > 0) {
        NSMutableDictionary* richLandingActionDict = [NSMutableDictionary dictionary];
        richLandingActionDict[kInboxKeyActionType] = kInboxValActionTypeNav;
        richLandingActionDict[kInboxKeyActionNavType] = kInboxValNavActionRichLanding;
        richLandingActionDict[kInboxKeyActionValue] = self.richLandingURL;
        richLandingActionDict[kInboxKeyActionKVPair] = self.screenDataDict;
        
        [actionsArray addObject:richLandingActionDict];
    }
    return actionsArray;
}
@end
