//
//  MintEvents.h
//  RideScout
//
//  Created by Nicholas Petersen on 2/26/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#ifndef RideScout_MintEvents_h
#define RideScout_MintEvents_h

//Events in OnboardingViewController
// Legacy Events
#define APP_LAUNCH @"app launch"
#define START_SCOUTING_BUTTON_TOUCHED @"start scouting button touched"
#define CREATE_ACCT_BUTTON_TOUCHED @"create account button touched"
#define ALREADY_HAVE_ACCT_BUTTON_TOUCHED @"already have account button touched"
#define START_SCOUTING_BUTTON_TOUCHED @"start scouting button touched"
#define SKIP_BUTTON_PRESSED @"skip onboarding button touched"
#define DONE_ONBOARDING @"onboarding complete"
// OnBoarding Event Prefixes
#define ONBOARDING_EXPLICIT @"Onboarding"
#define ONBOARDING_SCREEN_SHOWN @"Onboarding Screen Shown"
#define ONBOARDING_BUTTON_PRESS @"Onboarding Button Pressed"
// Onboarding Screen Titles
#define WELCOME_SCREEN_TITLE @"WELCOME"
#define EMAIL_SCREEN_TITLE @"EMAIL"
#define VERIFICATION_SCREEN_TITLE @"VERIFICATION"
#define ADDRESSES_SCREEN_TITLE @"ADDRESSES"
#define PASSWORD_SCREEN_TITLE @"PASSWORD"
#define SCOUTING_SCREEN_TITLE @"SCOUTING"
#define SIGN_IN_SCREEN_TITLE @"SIGN_IN"
#define PROVIDER_PREF_SCREEN_TITLE @"PROVIDER_PREF"
#define CONFIRMED_SCREEN_TITLE @"CONFIRMED"
#define FORGOT_PASSWORD_SCREEN_TITLE @"FORGOT_PASSWORD"
#define UNSUPPORTED_SCREEN_TITLE @"UNSUPPORTED CITY"
#define ENTER_LOCATION_SCREEN_TITLE @"LOCATION"
// OnBoarding Account Creation Events
#define ONBOARDING_ACCOUNT_CREATED @"account created"
#define ONBOARDING_ACCOUNT_CONFIRMED @"already had account"
#define ONBOARDING_ACCOUNT_SIGN_IN @"signed in with existing account";
#define ADDRESS @"Onboarding - Address";
// OnBoarding City Detection
#define ONBOARDING_CITY_DETECTED @"Onboarding - City Detected -"

// Profile/ HUB Event Prefixes
#define HUB_EXPLICIT @"HUB"
#define HUB_SCREEN_SHOWN @"HUB Screen Shown"
#define HUB_BUTTON_PRESS @"HUB Button Pressed"

// Popup Event Prefixes
#define POPUP_EXPLICIT @"Popup"
#define POPUP_SCREEN_SHOWN @"Popup Screen Shown"
#define POPUP_BUTTON_PRESS @"Popup Button Pressed"

//Events in LocationManager
#define UPDATING_CLVISIT_LOCATION @"cl visit - updating location" 
#define CLVISIT_SAVED_TO_PHONE @"cl visit - visit saved to phone"
#define CLVISIT_STOPPED_UPDATING_LOCATION @"clvisit stopped updating location"
//Events in AppDelegate
#define START_UPDATING_LOCATION @"start updating location"
#define START_MONITORING_LOCATION_VISITS @"start monitoring location visits"
#define RETURN_USER_THREE_PLUS @"user has opened the app over 3 times"
#define NEW_USER @"first application launch - new user"
#define APP_RESIGN_ACTIVE @"application will resign active"
#define APP_ENTERED_BG @"application did enter background"
#define APP_ENTERS_FG @"application will enter foreground"
#define APP_BECOMES_ACTIVE @"application did become active"
#define APP_WILL_TERMINATE  @"application will terminate"
#define THIRDPARTY_SETUP @"setup third party services"
#define SETUP_GGLE_CONV_TRACKING @"setup google conversion tracking"
#define MOBILE_APP_TRACKING_SETUP @ "setup mobile app tracking"
#define MAPBOX_SETUP @"setup mapbox"
#define SPLUNK_SETUP @"setup splunk"
#define  NSMANAGED_OBJECT_CONTEXT "NSManagedObjectContext: coordinator"
#define MANAGED_OBJECT_MODEL @"managed object model"
#define PERSISTENT_STORE_COORDINATOR @"persistent store coordinator"
#define APPLICATION_DOCUMENTS_DIRECTORY @"application documents directory"
//Events in ExplodeAnimator
#define EXPLODE_ANIMATION @"explode animation"
#define REVERSE_EXPLOSION_ANIMATION @"reverse explosion animation"
//Events in MapSlideDown
#define MAP_SLIDES_DOWN @"map slides down"
#define MAP_REVERSE_SLIDES_DOWN @"map reverse slide down"
//Events in RSAlertView
#define SHOW_RSALERTVIEW @"show RSAlertView"
#define CUSTOMIOS7_DIAL_BUTTON_TOUCHUI @"custom iOS7 dialogue button touch up inside"
#define CUSTOMIOS7_DIAL_BUTTON_TOUCHUI_DEF @"custom iOS7 dialogue button touch up inside default behavior"
#define RSALERT_GET_TEXT @"get text in RSAlertView"
#define CLOSE_RSALERTVIEW @"close RSAlertView"
#define APPLY_MOTION_EFFECTS @"apply motion effects"
#define KEYBOARD_WILL_SHOW @"keyboard will show"
#define KEYBOARD_WILL_HIDE @"keyboard will hide"
#define CREATE_CONTENT_WITH_TITLE @"create content with title for RSAlertView"
#define SHAKE_FOR_VIEW @"shake view"
//Events in TripCircleView
#define ZOOM_TO_POLYLINE_API @"zoom to polyline API call"
//Events in ProfileCircleView
#define BUILD_PROFILE_CIRCULAR_VIEW @"build profile circular view"
//Events in ProviderCircleView
#define BUILD_PROVIDER_CIRCLE_VIEW @"build provider circular view"
//Events in CityCirlceView
#define BUILD_CIRCLE_VIEW @"build circle view"
//Events in AccountDetailsWidget
#define ACCOUNT_DET_WGT_BLD @"account details widget built"
//Events in NextTransitRideDetailsWidget
#define NEXT_TRANSIT_RIDE_DET_WGT_BLD @"next transit ride details widget built"
//Events in PaymentDetailsWidget
#define PMNT_DET_WGT_BLD @"payment details widget built"
#define ADD_CC_NICKNAME @"add credit card nickname"
#define REMOVE_CC @"remove credit card"
#define SET_DEF_CC @"set default credit card"
//Events in RidesNearbyWidget
#define RIDES_NEARBY_DET_WGT_BLD @"rides nearby widget built"
#define LOAD_PROVIDERS_API_RN @"rides nearby load providers API"
//Events in MoreRidesNearbyWidget
#define MORE_RIDES_NEARBY_WIDGET @"more rides nearby widget built"
#define LOAD_PROVIDERS_API_MRN @"more rides nearby load providers API"
//Events in ProfileManager
#define LOGOUT_SUCCESS @"profile manager logout success"
#define LOGOUT_FAIL @"profile manager logout fail"
#define REGISTER_ACCT_EMAIL_SUCCESS @"profile manager register account for email success"
#define REGISTER_ACCT_PHONE_NUMBER_SUCCESS @"profile manager register account for phone number success"
#define REGISTER_ACCT_EMAIL_FAIL @"profile manager register account for email fail"
#define REGISTER_ACCT_PHONE_NUMBER_FAIL @"profile manager register account for phone number fail"
#define FORGOT_PASSWORD_SUCCESS @"profile manager forgot password request success"
#define FORGOT_PASSWORD_FAIL @"profile manager forgot password request fail"
//Events in RideIconsManager
#define ADD_IMAGE @"add icon image for URL"


//Events in RideOptionsViewController
#define LOGIN_BUTTON_TOUCHED @"Login button touched"
#define LOGOUT_BUTTON_TOUCHED @"Logout button touched"
#define CHANGE_CURRENT_LOC_BUTTON_TOUCHED @"Change current location button touched"
#define PULL_DOWN_TO_UPDATE_RIDES_NEARBY @"Pull to update rides nearby"
#define EXPLODE_MAP @"Map expanded to entire screen"
#define CC_FAIL_WARNING @"Received credit card failure warning"
#define CC_INFO_ADDED @"Added credit card information"
#define CC_CANCELLED_ADD @"User cancelled adding payment option"
#define PAGE_SWIPE_FROM_PROVIDER @"Page swipe from provider"

//Events in SocialLoginViewController
#define LOGIN_BACK_BUTTON_TOUCHED @"Login back button touched"
#define LOGIN_CANCEL_BUTTON_TOUCHED @"Login cancel button touched"
#define LOGINVIEW_LOGIN_BUTTON_TOUCHED @"Login button touched"
#define ACCESS_TOKEN_SUCCESS @"Access token success"
#define ACCESS_TOKEN_FAIL @"Access token fail"
#define LOGIN_SUCCESS @"Login success"
#define LOGIN_ERROR_INPUT_INVALID @"Login error - username or password entered was incorrect"
#define REGISTER_BUTTON_TOUCHED @"Register for a new account button touched"
#define PASSWORD_BUTTON_TOUCHED @"Forgot password button touched"

//PageView
#define SUGGESTION_VIEW_TAPPED @"SuggestionView tapped"
#define ROUTE_SCHEDULE_PRESENTED @"Route schedule presented"
#define BOUNCED_TO_PROVIDER @"Bounced to provider"
#define BOUNCED_TO_PROVIDER_FOR_DOWNLOAD @"Bounced to download for provider"
#define X_CALLBACK_TO_PROVIDER @"XCallback to provider"
#define X_CALLBACK_TO_DOWNLOAD_FOR_PROVIDER @"XCallback to download for provider"

//MoreRideOptionsView
#define SELECTED_DIFFERENT_RIDE_OPTION @"User selected a different ride option"

//TravelOptionsView
#define TRAVEL_OPTIONS_PLACE_CHANGED @"Travel option place changed"
#define TRAVEL_OPTIONS_DIRECTION_TYPE_CHANGED @"Travel option direction type changed"
#define TRAVEL_OPTIONS_TRAVEL_TIME_CHANGED @"Travel option travel time changed"
#define TRAVEL_OPTIONS_GOOGLE_PLACE @"Travel option user selected searched location"

//MapViewController
#define DIRECTION_VIEW_PRESENTED @"Direction view presented"
#define MAP_VIEW_BACK_BUTTON_TOUCHED @"Map view back button touched"


#pragma mark - Booking Flows

// Processes
// -- Providers
#define PROCESS_BCYCLE @"BCycle"

// RideScout Feature
#define BOOKING @"Booking"
#define UNLOCK @"Unlock"
#define RESERVE @"Reserve"
#define REGISTER @"Register"

// Actions
#define PRESSBUTTON @"Press Button"
#define DISPLAY @"Display"
#define EXIT_FLOW @"Exit"

// Major UI Elements
// -- Menus
#define BOOKING_MENU @"Booking Menu"

// -- Popups
#define PIN_POPUP @"PIN Popup"
#define INCOMPLETE_PIN_POPUP @"Incomplete PIN Popup"
#define LOADING_POPUP @"Loading Popup"
#define SUCCESS_POPUP @"Success Popup"
#define FAILURE_POPUP @"Failure Popup"
#define RIDESCOUT_ERROR_POPUP @"RideScout Error Popup"
#define EXISTING_RESERVATION_POPUP @"Existing Reservation Popup"

// -- -- Provider-Specific Popups
#define BCYCLE_ERROR_POPUP @"BCycle Error Popup"
#define DOCK_POPUP @"Dock Popup"

// -- Views
#define INCOMPLETE_PROFILE_VIEW @"Incomplete Profile View"


// Minor UI Elements
// -- Buttons
#define UNLOCK_BUTTON @"Unlock"
#define RESERVE_BUTTON @"Reserve"
#define CANCEL_RESERVATION_BUTTON @"Cancel Reservation"

#define OK_BUTTON @"OK"
#define CANCEL_BUTTON @"Cancel"
#define TERMS_AND_CONDITIONS_BUTTON @"Terms and Conditions"

#endif
