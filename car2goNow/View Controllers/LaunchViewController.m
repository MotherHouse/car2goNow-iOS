//
//  LaunchViewController.m
//  RideScout
//
//  Created by Brady Miller on 9/14/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "LaunchViewController.h"
#import "LocationManager.h"
#import "constantsAndMacros.h"
#import "LoadingRidesViewController.h"
#import "UnsupportedCityViewController.h"
#import "RSProfileManager.h"
#import "TripManager.h"
#import "MintManager.h"
#import "ConfigManager.h"
#import "RSProfileManager.h"
#import <RideKit/RideKit.h>
#import <RideKit/RKOnboardingAnimator.h>
#import <RideKit/RKRadialGradient.h>
@import MobileCoreServices;
@import WatchConnectivity;

@interface LaunchViewController () <UINavigationControllerDelegate, RideKitDelegate, WCSessionDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;
@property (nonatomic, assign) BOOL threeSecondDelay;
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, assign) BOOL loadedLogin;
@property (nonatomic, assign) BOOL supportedCity;
@property (nonatomic, assign) BOOL loadedSupportedCity;
@property (nonatomic, assign) BOOL calledNextScreen;
@property (nonatomic, strong) NSString *cityName;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.gradientLayer.opacity = 0.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundLocation:) name:FOUNDLOCATION object:nil];
    [[LocationManager sharedLocationManager] startUpdatingLocationNotify:YES];
    [[LocationManager sharedLocationManager] startMonitoringVisits];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(delayOccurred) userInfo:nil repeats:NO];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 0.80;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.additive = NO;
    [self.gradientLayer addAnimation:animation forKey:nil];
    
    [[RKManager sharedService] setDelegate:self];
    
    [self startAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FOUNDLOCATION object:nil];
}

#pragma mark - Login and Supported City Checks

- (void)checkLogin {
//    self.loadedLogin = YES;
//    self.loggedIn = NO;
    
//    [[RKManager sharedService] checkForLoggedInProfileWithSuccess:^(RKProfile *profile) {
//        [MintManager splunkWithString:(ONBOARDING_EXPLICIT @" - Previous User Logged In") event:NO breadcrumb:YES];
//        [[RSProfileManager sharedManager] getProfileWithSuccess:nil failure:nil];
//#pragma warning - Fix Places and Trips
////        [[TripManager sharedTripManager] getMostRecentReceipts:[NSNumber numberWithInt:3]];
////        [[PlacesManager sharedPlacesManager] getPlaceWithSuccess:nil withErrorHandler:nil];
//        self.loadedLogin = YES;
//        self.loggedIn = YES;
//        if (self.loadedSupportedCity && self.threeSecondDelay) [self nextViewController];
//    } failure:^{
//        self.loadedLogin = YES;
//        self.loggedIn = NO;
//        
//        if (self.loadedSupportedCity && self.threeSecondDelay) [self nextViewController];
//    }];
}

- (void)foundLocation:(NSNotification *)notification {
    // Get Config.... hmmmmmmm
//    [[ConfigManager sharedConfiguration] getConfig];
    
//    self.loadedSupportedCity = YES;
//    self.supportedCity = YES;
//    if (self.loadedLogin && self.threeSecondDelay) [self nextViewController];
    
        CLLocation *location = [[LocationManager sharedLocationManager] currentLocation];
        [LocationManager checkSupportedCityForLat:location.coordinate.latitude andLng:location.coordinate.longitude completion:^(BOOL supported, NSString *cityName) {
            self.loadedSupportedCity = YES;
            self.supportedCity = supported;
            self.cityName = cityName;
    
            if (self.loadedLogin && self.threeSecondDelay) [self nextViewController];
        }];
}

- (void)delayOccurred {
    self.threeSecondDelay = YES;
    if (self.loadedLogin && self.loadedSupportedCity)
        [self nextViewController];
}

- (void)nextViewController {
    self.calledNextScreen = YES;
    
    if (self.loggedIn && self.supportedCity) {
        LoadingRidesViewController *vc = [[LoadingRidesViewController alloc] init];
        [vc setLoadAnimation:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (!self.loggedIn && self.supportedCity) {
        [[RKManager sharedService] getRidersLicense:^(RKOnboardingViewController *vc) {
            LoadingRidesViewController *loadingRides = [[LoadingRidesViewController alloc] init];
            if ([vc class] == NSClassFromString(@"RKEnterTextCodeViewController")) {
                [loadingRides setLoadAnimation:YES];
            }
            [vc.navigationController pushViewController:loadingRides animated:YES];
        }];
    }
    else if (!self.supportedCity) {
        UnsupportedCityViewController *vc = [[UnsupportedCityViewController alloc] init];
        [vc setCityName:self.cityName];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Ride Kit Delegate

- (void)loggedInWithProfile:(RKProfile *)profile {
    
    if (self.calledNextScreen) return;
    
    [TripManager sharedTripManager];
    [RSProfileManager sharedManager];
    
    if (profile) {
        self.loadedLogin = YES;
        self.loggedIn = YES;
        if (self.loadedSupportedCity && self.threeSecondDelay) [self nextViewController];
    }
    else {
        self.loadedLogin = YES;
        self.loggedIn = NO;
        
        if (self.loadedSupportedCity && self.threeSecondDelay) [self nextViewController];
    }
}

#pragma mark - View Controller Animators

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [[RKOnboardingAnimator alloc] init];
}

#pragma mark - Watch Connectivity

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rk_login_id"];
    if (refreshToken) replyHandler(@{@"refresh_token":refreshToken});
    else replyHandler(@{@"refresh_token":@"NotAvailable"});
}

@end
