#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import <MoEPluginBase/MOInAppCampaign+Utility.h>
#import <MoEPluginBase/MOInAppSelfHandledCampaign+Utility.h>
#import <MoEPluginBase/MoEPluginBridge.h>
#import <MoEPluginBase/MoEPluginConstants.h>
#import <MoEPluginBase/MoEPluginInitializer.h>
#import <MoEPluginBase/MoEPluginMessage.h>
#import <MoEPluginBase/MoEPluginMessageQueueHandler.h>
#import <MoEPluginBase/MoEPluginUtils.h>
#import <MoEPluginBase/MoEPluginCoordinator.h>


FOUNDATION_EXPORT double MoEPluginBaseVersionNumber;
FOUNDATION_EXPORT const unsigned char MoEPluginBaseVersionString[];

