//
//  constantsAndMacros.h
//  RideScout
//
//  Created by Brady Miller on 2/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#if USE_NIGHTLY_SERVER
#define API_URL @"https://nightly.gateway.ridescout.com/" // Engineering API
#else
#define API_URL @"https://beta.gateway.ridescout.com/" // "Stable" API
#endif

#if USE_NIGHTLY_SERVER
#define API_KEY @"e8d08b74575360f704bbeb254278ff2f" // Engineering API Key
#else
#define API_KEY @"9eb287470930676fe5064ee94488f7a5" // Stable API Key
#endif

#define RIDES_RADIUS 1000
#define API_VERSION 7

#if DEBUG
#define RSLog(format, ...) NSLog(@"%@", [NSString stringWithFormat:format, ##__VA_ARGS__])
#else
#define RSLog(format, ...) {}
#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define BCYCLE_DARK_BLUE [UIColor colorWithRed:35.0/255.0 green:37.0/255.0 blue:120.0/255.0 alpha:1.0]
#define BCYCLE_BLUE [UIColor colorWithRed:57.0/255.0 green:60.0/255.0 blue:183.0/255.0 alpha:1.0]
#define BCYCLE_LIGHT_PURPLE [UIColor colorWithRed:122.0/255.0 green:123.0/255.0 blue:204.0/255.0 alpha:1.0]
#define BCYCLE_RED [UIColor colorWithRed:204.0/255.0 green:51.0/255.0 blue:66.0/255.0 alpha:1.0]
#define BCYCLE_DARK_GREY [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]
#define BCYCLE_LIGHT_GREY [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0]

#define RIDESCOUT_GREEN [UIColor colorWithRed:0.0/255.0 green:173.0/255.0 blue:154.0/255.0 alpha:1.0]
#define RIDESCOUT_LIGHT_GREY [UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0]
#define RIDESCOUT_DARK_GREY [UIColor colorWithRed:75.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1.0]
#define RIDESCOUT_LIGHT_GREY_DIVIDER [UIColor colorWithRed:62.0/255.0 green:65.0/255.0 blue:69.0/255.0 alpha:1.0]
#define RIDESCOUT_ORANGE_ERROR [UIColor colorWithRed:228.0/255.0 green:124.0/255.0 blue:13.0/255.0 alpha:1.0]
#define RIDESCOUT_WHITE [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]
#define RIDESCOUT_NAVY [UIColor colorWithRed:49.0/255.0 green:55.0/255.0 blue:62.0/255.0 alpha:1.0]

#define COOPER_GRAY [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]

#define STANDARD_CELL_HEIGHT 44
#define STANDARD_LINE_WEIGHT 0.5

#define PINSENTFROMEMAIL @"PinSentFromEmail"
#define LINKSENTFROMLOGIN @"LinkSentFromOnlineLogin"
#define RIDESNEARBYDONE @"RidesNearbyDone"
#define FOUNDLOCATION @"FoundLocation"
#define CITYPROVIDERSLOADED @"CityProvidersLoaded"
#define CITYPROVIDERSTIMEDOUT @"CityProviderstimedOut"
#define CITYUPDATED @"CityUpdate"
#define UPDATEDPROFILE @"UpdatedProfile"
#define SENDPREFERENCES @"SendPreferences"
#define RIDEDIRECTIONSDONE @"RideDirectionsDone"
#define CREDITCARDADDED @"CreditCardAdded"
#define CITYADDED @"CityAdded"
#define SELECTEDRIDE @"SelectedRide"
#define TRANSITSCHEDULEUPDATED @"TransitScheduleUpdated"
#define TRANSITSUGGESTEDRIDEDONE @"TransitSuggestedRideDone"
#define TRANSITSCHEDULEDONE @"TransitScheduleDone"
#define LOCATIONCHANGE @"LocationChanged"
#define PROFILESELECTEDPLACECHANGE @"ProfileSelectedPlaceChange"

//USERDEFAULTS
#define UD_RECENTPLACES @"RecentPlaces"

// Reachability Notifcaiotn
#define AFNETWORKUNREACHABLE @"AFNetworkingUnreachable"
#define AFNETWORKREACHABLE @"AFNetworkingReachable"

// Receiving Request for the User's Access Token
#define ACCESSTOKENRECEIVED @"AccessTokenRequested"

// Helpers
#define SCREEN CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WITH_HEIGHT(height) CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, height)
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEGREES_TO_RADIANS( degrees ) ( ( degrees ) / 180.0 * M_PI )

// Notifications
#define PRESENT_PROFILE_VC_NOTIFICATION @"Present Profile VC"
#define PRESENT_RIDERS_LICENSE_VC_NOTIFICATION @"Present Riders License VC"

// External Identifiers
#define CONTACT_SUPPORT_PHONE_NUMBER @"5126862633"
#define CONTACT_SUPPORT_EMAIL_ADDRESS @"support@ridescout.com"

