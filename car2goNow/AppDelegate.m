//
//  AppDelegate.m
//  Bcycle
//
//  Created by Brady Miller on 9/25/15.
//  Copyright © 2015 ridescout. All rights reserved.
//

#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>

#import <CoreData/CoreData.h>
#import <SplunkMint/SplunkMint.h>
#import <RideKit/RideKit.h>

#import "MintManager.h"
#import "UIDevice+Resolutions.h"
#import "GAI.h"
#import "GAITracker.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "RidesNearbyManager.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "AFNetworking.h"
#import <Mapbox-iOS-SDK/Mapbox.h>

#import "Receipt.h"

#import "LaunchViewController.h"
#import "ReceiptViewController.h"

#import "ConfigManager.h"
#import "LocationManager.h"
#import "RSProfileManager.h"
#import "TripManager.h"

#import "constantsAndMacros.h"
#import <CardIO/CardIO.h>

#define WEBVIEW_INSET 15
#define X_INSET 10

@interface AppDelegate ()

@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) NSTimer *connectionTimer;
@property (nonatomic, strong) NSDate *lastConnnectionTime;

@end

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupThirdPartyServices];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set up the Base NavigationController
    self.navController = [[UINavigationController alloc] init];
    [self.navController setNavigationBarHidden:YES];
    
    LaunchViewController *vc = [[LaunchViewController alloc] init];
    [vc checkLogin];
    [self.navController pushViewController:vc animated:NO];
    
    // Display the appropriate View Controller
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    // Notifications
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [application registerUserNotificationSettings:settings];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        // Returning user
        int appOpens = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NumberOfAppOpens"] intValue];
        appOpens++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:appOpens] forKey:@"NumberOfAppOpens"];
        if (appOpens == 3) {
            [MintManager splunkWithString:RETURN_USER_THREE_PLUS event:YES breadcrumb:YES];
        }
    }
    else {
        // First time launch
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"NumberOfAppOpens"];
        
        [MintManager splunkWithString:NEW_USER event:YES breadcrumb:YES];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [MintManager splunkWithString:APP_RESIGN_ACTIVE event:NO breadcrumb:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [MintManager splunkWithString:APP_ENTERED_BG event:NO breadcrumb:YES];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MintManager splunkWithString:APP_WILL_TERMINATE event:YES breadcrumb:YES];
    
    [[LocationManager sharedLocationManager] stopUpdatingLocation];
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [[LocationManager sharedLocationManager] stopMonitoringVisits];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SENDPREFERENCES object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
#pragma warning - Future Charlie... you totally dont want to do this - love: Past Charlie
    //    [[LocationManager sharedLocationManager] startUpdatingLocationNotify:NO];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [MintManager flush];
    
    [MintManager splunkWithString:APP_BECOMES_ACTIVE event:NO breadcrumb:YES];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BOOL isRideKitLink = [[RKManager sharedService] handleOpenURL:url];
    if (isRideKitLink) return YES;
    //    else if ([url.absoluteString rangeOfString:@"ridescout://change-password/?code="].location != NSNotFound) {
    //        NSString *pin = [url.absoluteString stringByReplacingOccurrencesOfString:@"ridescout://change-password/?code=" withString:@""];
    //        [[NSNotificationCenter defaultCenter] postNotificationName:PINSENTFROMEMAIL object:nil userInfo:@{@"code" : pin}];
    //    }
    else if ([url.absoluteString rangeOfString:@"ridescout://login/"].location != NSNotFound) {
        //        OnboardingViewController *vc = [[OnboardingViewController alloc] init];
        //        [self.navController pushViewController:vc animated:NO];
        //        self.window.rootViewController = self.navController;
        //        [self.window makeKeyAndVisible];
        //        vc.context.currentAction = oaReEnterFlowFromLoginLink;
    }
    return YES;
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"push_token"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // URL Notification Callback
    NSString *urlString = [userInfo stringForKey:@"url"];
    if (urlString.length > 0) {
        if (self.loginView) [self.loginView removeFromSuperview];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [self buildWebViewWithRequest:request];
    }
    
    NSString *pushType = [userInfo stringForKey:@"push_type"];
    if ( application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        if ( [pushType isEqualToString:@"receipt"] ) {
            [self handleTripReceiptPushNotification:userInfo];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)handleTripReceiptPushNotification:(NSDictionary *)userInfo {
    // Trip Points
    NSString *tripID = [userInfo stringForKey:@"id"];
    NSArray *tripPoints = [[LocationManager sharedLocationManager] stopCollectingPointsForTrip];
    [TripManager updateTripWithID:tripID withTripPoints:tripPoints withSuccess:nil WithErrorHandler:nil];
    NSString *receiptStr = [userInfo stringForKey:@"data"];
    NSData *objectData = [receiptStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *receiptData = [NSJSONSerialization JSONObjectWithData:objectData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
    Receipt *newReceipt = [[Receipt alloc] initWithDictionary:receiptData];
    ReceiptViewController *receiptVC = [[ReceiptViewController alloc] initWithReceipt:newReceipt];
    [self.navController pushViewController:receiptVC animated:NO];
}

- (void)buildWebViewWithRequest:(NSURLRequest *)request {
    self.loginView = [[UIView alloc] init];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.loginView setFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    [self.loginView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.30]];
    
    UIImageView *webviewShadow = [[UIImageView alloc] initWithFrame:CGRectMake(WEBVIEW_INSET - 1, WEBVIEW_INSET + 20 - 1, screenRect.size.width - 2 * WEBVIEW_INSET + 2, screenRect.size.height - 2 * WEBVIEW_INSET - 20 + 2)];
    [webviewShadow setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.35]];
    [self.loginView addSubview:webviewShadow];
    
    UIWebView *ridescoutLoginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(WEBVIEW_INSET, WEBVIEW_INSET + 20, screenRect.size.width - 2 * WEBVIEW_INSET, screenRect.size.height - 2 * WEBVIEW_INSET - 20)];
    [ridescoutLoginWebView loadRequest:request];
    [self.loginView addSubview:ridescoutLoginWebView];
    
    UIImageView *exitShadow = [[UIImageView alloc] initWithFrame:CGRectMake(WEBVIEW_INSET - X_INSET - 1, WEBVIEW_INSET - X_INSET - 1 + 20, 32, 32)];
    [exitShadow setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.35]];
    [exitShadow.layer setCornerRadius:exitShadow.frame.size.height / 2];
    [self.loginView addSubview:exitShadow];
    
    UIView *exitLoginView = [[UIView alloc] initWithFrame:CGRectMake(WEBVIEW_INSET - X_INSET, WEBVIEW_INSET - X_INSET + 20, 30, 30)];
    [exitLoginView setBackgroundColor:[UIColor blackColor]];
    [exitLoginView.layer setBorderWidth:3];
    [exitLoginView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [exitLoginView.layer setCornerRadius:exitLoginView.frame.size.height / 2];
    [exitLoginView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup)]];
    
    UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
    [xLabel setText:@"x"];
    [xLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14]];
    [xLabel setTextColor:[UIColor whiteColor]];
    [xLabel setTextAlignment:NSTextAlignmentCenter];
    [exitLoginView addSubview:xLabel];
    [self.loginView addSubview:exitLoginView];
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    [topController.view addSubview:self.loginView];
}

- (void)closePopup {
    [UIView animateWithDuration:.3 animations:^{
        self.loginView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.loginView removeFromSuperview];
    }];
}

#pragma mark - Setup

- (void)setupThirdPartyServices {
    [self setupMapBox];
    [self setupSplunk];
    [self setupGoogleAnalytics];
    [self setUpRideKit];
    [self setupCrashlytics];
    [self setupAFNetworkReachability];
}

- (void)setupMapBox {
    [[RMConfiguration sharedInstance] setAccessToken:@"sk.eyJ1IjoiYWNvbGxpZXI4OCIsImEiOiIxejRqdVc0In0.OayYGUlkfwiJS8fXj0AJWQ"];
}

- (void)setupSplunk {
    //Start MINT Session and Add ifa and ifv to ExtraData field
    [[Mint sharedInstance] initAndStartSession:@"613e4e15"];
    
    NSUUID *idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    [[Mint sharedInstance] setUserIdentifier:(NSString *)idfa.UUIDString];
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    ExtraData *ios_ifa = [[ExtraData alloc] initWithKey:@"ios_ifa" andValue:(NSString *)idfa.UUIDString];
    ExtraData *ios_ifv = [[ExtraData alloc] initWithKey:@"ios_ifv" andValue:(NSString *)idfv.uppercaseString];
    
    [[Mint sharedInstance] addExtraData:ios_ifv];
    [[Mint sharedInstance] addExtraData:ios_ifa];
}

- (void)setupGoogleAnalytics {
    // Google Analytics
    [[GAI sharedInstance] setDispatchInterval:20]; // Set Google Analytics dispatch interval to 20 seconds.
    [[GAI sharedInstance] setDryRun:NO];
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone]; // Sets the logger to verbose for debug information
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-46004088-2"];
}

- (void)setUpRideKit {
    
#if USE_NIGHTLY_SERVER
    RKConfiguration *config = [[RKConfiguration alloc] initWithApiKey:@"e8d08b74575360f704bbeb254278ff2f" callbackUrlScheme:@"ridescout" needAccount:YES andFeatures:@[]];
#else
    RKConfiguration *config = [[RKConfiguration alloc] initWithApiKey:@"9eb287470930676fe5064ee94488f7a5" callbackUrlScheme:@"ridescout" needAccount:YES andFeatures:@[]];
#endif
    [[RKManager sharedService] setPrimaryColor:BCYCLE_DARK_BLUE];
    [[RKManager sharedService] setSecondaryColor:[UIColor whiteColor]];
    [[RKManager sharedService] setIcon:[UIImage imageNamed:@"bcycle_logo.png"]];;
    [[RKManager sharedService] startRideKitWithConfiguration:config completion:^(NSArray *providers) {
        
    }];
}

- (void)setupCrashlytics {
    [Fabric with:@[CrashlyticsKit]];
}

- (void)setupAFNetworkReachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //            self.connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(noConnectionAfterDelay:) userInfo:nil repeats:NO];
            if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AFNETWORKUNREACHABLE object:nil];
            }
        }
        else {
            [self.connectionTimer invalidate];
            [[NSNotificationCenter defaultCenter] postNotificationName:AFNETWORKREACHABLE object:nil];
            if ([[NSDate date] timeIntervalSinceDate:self.lastConnnectionTime] > 120)
                [[NSNotificationCenter defaultCenter] postNotificationName:LOCATIONCHANGE object:nil];
            self.lastConnnectionTime = [NSDate date];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) self.lastConnnectionTime = [NSDate date];
}

- (void)noConnectionAfterDelay:(NSTimer *)timer {
    if (timer.isValid && ![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNETWORKUNREACHABLE object:nil];
    }
}

@end
