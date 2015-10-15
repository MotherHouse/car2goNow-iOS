//
//  LoadingRidesViewController.m
//  RideScout
//
//  Created by Brady Miller on 7/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "LoadingRidesViewController.h"
#import "MapViewController.h"
#import "DirectionsManager.h"
#import "AppDelegate.h"

#import "FLAnimatedImage.h"

#import "LocationManager.h"
#import "RidesNearbyManager.h"
#import "CityProviderManager.h"

#import "QuestionPopup.h"

#define LOCATION_TIMEOUT 10.0


@interface LoadingRidesViewController ()<UINavigationControllerDelegate, UIWebViewDelegate> {
    NSTimer *locationTimer;
    
    NSTimer *locationUpdateTimer;
    NSTimer *locationTimeoutTimer;
}

@property (nonatomic, assign) BOOL webViewDoneLoading;
@property (nonatomic, copy) void (^completion)(void);

@end

@implementation LoadingRidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocationTimers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupAnimationWebView];
    [self displayLoadingView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

#pragma mark - Locaiton Timers

- (void)startLocationTimers {
    // Set Up the Timer to Check the Location Manager
    locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(locationTimerDidUpdate) userInfo:nil repeats:YES];
    locationTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_TIMEOUT target:self selector:@selector(locationTimerDidTimeout) userInfo:nil repeats:NO];
}

- (void)locationTimerDidUpdate {
    if ( [LocationManager sharedLocationManager].currentLocation ) {
        // Invalidate the Timers
        [locationUpdateTimer invalidate];
        [locationTimeoutTimer invalidate];

        // Determine the Current Location
//        CLLocation *location = [LocationManager sharedLocationManager].currentLocation;

        [self launchRideSearch];
//        // Make the City Providrs API Call
//        [[CityProviderManager sharedProvidersForCity] getProvidersInCityAtLocation:location WithSuccess:^{
//            
//            // Load the Array of PRoviders for the Current City
//            NSArray *currentCityProviders = [[CityProviderManager sharedProvidersForCity] providers];
//            if ( currentCityProviders.count <= 0 ) {
//                [self presentUnsupportedLocationPopup];
//            }
//            else {
//                [self launchRideSearch];
//            }
//        } WithFailure:^{
//            [self presentUnsupportedLocationPopup];
//        }];
    }
}

- (void)locationTimerDidTimeout {
    // Invalidate the Timers
    [locationUpdateTimer invalidate];
    [locationTimeoutTimer invalidate];
    
    // Present the Unsuported City Popup
    [self presentUnsupportedLocationPopup];
}

#pragma mark - Display the View Components

- (void)displayLoadingView {    
        
}

#pragma mark - Display the View States

- (void)launchRideSearch {
    if ([LocationManager sharedLocationManager].currentLocation ) {
        [locationTimer invalidate];
        [[RidesNearbyManager sharedRidesByLocation] updateRidesNearbyWithCompletion:^{
            if ([[[[RidesNearbyManager sharedRidesByLocation] rideOptions] providers] count] == 0) {
                [self presentNoRidesPopup];
            }
            else {
                MapViewController *vc = [[MapViewController alloc] init];
                
                NSArray *providers = [[[RidesNearbyManager sharedRidesByLocation] rideOptions] providers];
                Provider *provider = [providers firstObject];
                vc.provider = provider;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

#pragma mark - View Controller Animators

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return nil;
}

#pragma mark - Unsupported Location

- (void)presentUnsupportedLocationPopup {
    // Prompt the User to enter his Credit Card or Driver's License
    QuestionPopup *popup = [[QuestionPopup alloc] init];
    [popup.headerLabel setText:@"No Providers!"];
    [popup setQuestionText:@"Oh Snap! We can't seem to find any providers in your city! Make sure your GPS is turned on and try again."];
    [popup setCancelLabelText:@"OK"];
    [popup setAcceptanceButtonHidden:YES];
    [popup setCanceledBlock:^(RKPopup *popup) {
        [popup closePopupCompletion:^{
            [self startLocationTimers];
        }];
    }];
    [popup presentPopupFromCenterPoint:self.view.center completion:nil];
}

- (void)presentNoRidesPopup {
    // Prompt the User to enter his Credit Card or Driver's License
    QuestionPopup *popup = [[QuestionPopup alloc] init];
    [popup.headerLabel setText:@"No rides nearby!"];
    [popup setQuestionText:@"We can't seem to find any rides near your location! Please try again later."];
    [popup setCancelLabelText:@"Try again"];
    [popup setAcceptanceButtonHidden:YES];
    [popup setCanceledBlock:^(RKPopup *popup) {
        [popup closePopupCompletion:^{
            [self launchRideSearch];
        }];
    }];
    [popup presentPopupFromCenterPoint:self.view.center completion:nil];
}

#pragma mark - Animation

- (void)setupAnimationWebView {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loader" ofType:@"html" inDirectory:@"RideKit.bundle"]];
    [self.loadingAnimation loadRequest:[NSURLRequest requestWithURL:url]];
    self.loadingAnimation.delegate = self;
    self.loadingAnimation.scrollView.scrollEnabled = NO;
    self.loadingAnimation.scalesPageToFit = YES;
    self.loadingAnimation.userInteractionEnabled = NO;
    self.loadingAnimation.alpha = 0;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webViewDoneLoading = YES;
    
    if (self.loadAnimation) {
        self.loadingAnimation.hidden = NO;
        [self.loadingAnimation stringByEvaluatingJavaScriptFromString:@"newAnimation(animSeq1);"];
        [UIView animateWithDuration:0.3 animations:^{
            self.loadingAnimation.alpha = 1.0;
            self.loadingRidesLabel.alpha = 1.0;
        }];
    }
    else {
        if (self.completion) {
            [self animationModeChange:self.completion];
        }
    }
}

- (void)loadStatic {
    [self.loadingAnimation stringByEvaluatingJavaScriptFromString:@"newAnimation(staticBus);"];
    self.loadingAnimation.alpha = 1;
}

- (void)animationModeChange:(void (^)(void))completion {
    self.completion = completion;
    
    if (self.webViewDoneLoading && completion) {
        [self.loadingAnimation stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"newAnimation(animSeq1);"]];
        completion();
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error : %@",error);
}

@end
