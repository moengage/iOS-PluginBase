# ChangeLog:
=================================
# 30th August 2023

## PluginBase 4.4.0
-------------------------------------------
* Handled Cards internal delegate setup.
* Updated the dependency to MoEngage-iOS-SDK 9.11.0

## Cards 1.1.0
-------------------------------------------
* Handled Cards internal delegate setup.
* Updated the dependency to MoEngage-iOS-SDK 9.11.0

## Inbox 2.4.0
-------------------------------------------
* Updated the dependency to MoEngage-iOS-SDK 9.11.0

## Geofence 2.4.0
-------------------------------------------
* Updated the dependency to MoEngage-iOS-SDK 9.11.0


# 25th July 2023
## Inbox 2.3.1
-------------------------------------------
* BugFix: Handled parsing issue is `fetchAllMessages` API.

# 18th Jul 2023
## Pluginbase 4.3.0
-------------------------------------------
* MoEngage-iOS-SDK dependency updated to 9.10.*.

## Inbox 2.3.0
-------------------------------------------
* MoEngageInbox dependency updated to 2.10.* 

## Geofence 2.3.0
-------------------------------------------
* MoEngageGeofence dependency updated to 5.10.*.

## Cards 1.0.0
-------------------------------------------
* Initial Release.

# 13th June 2023
## Pluginbase 4.2.1
-------------------------------------------
* BugFix: Added callback support for Selfhandled test/event triggered campaigns.

# 24th May 2023
## Pluginbase 4.2.0
-------------------------------------------
* MoEngage-iOS-SDK dependency updated to 9.8.*.

## Inbox 2.2.0
-------------------------------------------
* MoEngageInbox dependency updated to 4.8.* 

## Geofence 2.2.0
-------------------------------------------
* MoEngageGeofence dependency updated to 5.8.*.

# 16th February 2023
### Geofence 2.1.1
-------------------------------------------
* Added support for `stopGeofenceMonitoring` API.

# 6th February 2023
## Pluginbase 4.1.0
-------------------------------------------
* MoEngage-iOS-SDK dependency updated to 9.4.*.

## Inbox 2.1.0
-------------------------------------------
* MoEngageInbox dependency updated to 4.4.* 

## Geofence 2.1.0
-------------------------------------------
* MoEngageGeofence dependency updated to 5.4.*.

### Version 4.0.0   *(5th January 2023)*
-------------------------------------------
* MoEngage-iOS-SDK dependency updated to 9.2.* and MoEngageInApp dependency updated to 4.2.*.

### Version 3.1.1  *(12th December, 2022)*
-------------------------------------------
* Added an additional check to register for notification on app launch.

### Version 3.1.0  *(26th October, 2022)*
-------------------------------------------
* Updated MoEngage initialization method that accepts SDK state of type `MoEngageSDKState`.

### Version 3.0.0  *(22nd September, 2022)*
-------------------------------------------
* Renamed the module to `MoEngagePluginBase`
* MoEngage-iOS-SDK dependency updated to 8.3.* and MoEngageInApp dependency updated to 3.3.*.

### Version 2.3.1  *(02nd September, 2022)*
-------------------------------------------
* Fixed the crash due to multithreading.

### Version 2.2.0  *(24th November, 2021)*
-------------------------------------------
* Initialization method name fixes.

### Version 2.1.0  *(31st August, 2021)*
-------------------------------------------
* MoEngage-iOS-SDK dependency updated to 7.1.* and MoEngageInApp dependency updated to 2.1.*.
* HTML InApp Changes done.

### Version 2.0.2  *(12th February, 2021)*
-------------------------------------------
* Push Token Callback name updated.

### Version 2.0.1  *(10th February, 2021)*
-------------------------------------------
* Initialization methods updated to accept `MOSDKConfig` instance.

### Version 2.0.0  *(27th January, 2021)*
-------------------------------------------
* Deployment target updated to iOS 10.0.
* MoEngage-iOS-SDK dependency updated to 7.0.* and MoEngageInApp dependency updated to 2.0.*.

### Version 1.2.1  *(15th January, 2021)*
-------------------------------------------
* Import statement changes and updated MoEngageInApp dependency.

### Version 1.2.0  *(18th December, 2020)*
-------------------------------------------
* Enable/Disable SDK support added.
* PushToken Registration callback implementation.

### Version 1.1.1  *(7th December, 2020)*
-------------------------------------------
* UNUserNotificationCenter Delegate set only if its nil.

### Version 1.1.0  *(6th November, 2020)*
-------------------------------------------
* Inbox support added.
* Xcode 12 Build settings changes to exclude arm64 architecture for Simulator.

### Version 1.0.0  *(18th September, 2020)*
-------------------------------------------
* Initial Release with support for ReactNative,Cordova,Flutter and Unity.
