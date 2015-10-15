//
//  RSViewController.m
//  RideScout
//
//  Created by Charlie Cliff on 8/20/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RSViewController.h"
#import <RideKit/RKPinPopup.h>
#import "MessagePopup.h"
#import "MenuPopup.h"
#import "LocationManager.h"
#import "constantsAndMacros.h"
#import "messageCopy.h"

#import "AFNetworking.h"

@interface RSViewController () {
    CGPoint popupPresentationPoint;
}

@property (nonatomic) BOOL isPresentingNoGPSPopup;
@property (nonatomic) BOOL isPresentingNoInternetConnectionPopup;

@end

@implementation RSViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isPresentingNoGPSPopup = NO;
    popupPresentationPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNoGeoLocationView) name:NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNoInternetConnectionView) name:AFNETWORKUNREACHABLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisplay:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNETWORKUNREACHABLE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - Error State Popups

- (void)presentNoInternetConnectionView {
    [self presentNoInternetConnectionViewWithCompletion:nil];
}
- (void)presentNoInternetConnectionViewWithCompletion:(void(^)())completion {
    if ( !self.isPresentingNoInternetConnectionPopup ) {
        MenuPopup *popup = [[MenuPopup alloc] init];
        
        NSArray *menuButtons = [NSArray arrayWithObjects:NO_INTERNET_AVAILABLE_TRY_AGAIN_BUTTON, NO_INTERNET_AVAILABLE_OK_BUTTON, nil];
        [popup setActionTitles:menuButtons];
        
        __block __weak __typeof(self)blockSelf = self;
        MenuPopupCallback bcycleMenuSelection = ^(MenuPopup *menuPopup, NSInteger buttonIndex) {
            // Dismiss the Popup
            [menuPopup closePopupCompletion:^{
                if (completion) completion();
            }];
            blockSelf.isPresentingNoInternetConnectionPopup = NO;
            
            // UNLOCK BUTTON
            if (buttonIndex == 0) {                
                // Delay execution of my block for 10 seconds.
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:AFNETWORKUNREACHABLE object:nil];
                    }
                });
            }
        };
        [popup setCallback:bcycleMenuSelection];
        
        [popup.headerLabel setText:NO_INTERNET_AVAILABLE_ALERT_TITLE];
        [popup.headerLabel setFont:[UIFont fontWithName:NO_INTERNET_AVAILABLE_ALERT_TITLE_FONT size:NO_INTERNET_AVAILABLE_ALERT_TITLE_FONT_SIZE]];
        
        [popup.subTitleLabel setText:NO_INTERNET_AVAILABLE_ALERT_MESSAGE];
        [popup.subTitleLabel setFont:[UIFont fontWithName:NO_INTERNET_AVAILABLE_ALERT_MESSAGE_FONT size:NO_INTERNET_AVAILABLE_ALERT_MESSAGE_FONT_SIZE]];
        
        RSLabel *tryAgainLabal = [popup.actionLabels objectAtIndex:0];
        [tryAgainLabal setFont:[UIFont fontWithName:NO_INTERNET_AVAILABLE_TRY_AGAIN_BUTTON_FONT size:NO_INTERNET_AVAILABLE_TRY_AGAIN_BUTTON_FONT_SIZE]];
        
        RSLabel *okLabel = [popup.actionLabels objectAtIndex:1];
        [okLabel setFont:[UIFont fontWithName:NO_INTERNET_AVAILABLE_OK_BUTTON_BUTTON_FONT size:NO_INTERNET_AVAILABLE_OK_BUTTON_BUTTON_FONT_SIZE]];
        
        [popup presentPopupFromPoint:popupPresentationPoint ToPoint:popupPresentationPoint completion:nil];
        self.isPresentingNoInternetConnectionPopup = YES;
    }
}

- (void)presentNoGeoLocationView {
    if ( !self.isPresentingNoGPSPopup ) {
        MenuPopup *popup = [[MenuPopup alloc] init];
        
        NSArray *menuButtons = [NSArray arrayWithObjects:NO_GPS_AVAILABLE_TRY_AGAIN_BUTTON, NO_GPS_AVAILABLE_OK_BUTTON, nil];
        [popup setActionTitles:menuButtons];
        
        __block __weak __typeof(self)blockSelf = self;
        MenuPopupCallback bcycleMenuSelection = ^(MenuPopup *menuPopup, NSInteger buttonIndex) {
            // Dismiss the Popup
            [menuPopup closePopupCompletion:nil];
            blockSelf.isPresentingNoGPSPopup = NO;

            // UNLOCK BUTTON
            if (buttonIndex == 0) {
                [[LocationManager sharedLocationManager] determineLocationServicesAreEnabled];
            }
        };
        [popup setCallback:bcycleMenuSelection];
        
        [popup.headerLabel setText:NO_GPS_AVAILABLE_ALERT_TITLE];
        [popup.headerLabel setFont:[UIFont fontWithName:NO_GPS_AVAILABLE_ALERT_TITLE_FONT size:NO_GPS_AVAILABLE_ALERT_TITLE_FONT_SIZE]];

        [popup.subTitleLabel setText:NO_GPS_AVAILABLE_ALERT_MESSAGE];
        [popup.subTitleLabel setFont:[UIFont fontWithName:NO_GPS_AVAILABLE_ALERT_MESSAGE_FONT size:NO_GPS_AVAILABLE_ALERT_MESSAGE_FONT_SIZE]];
        
        RSLabel *tryAgainLabal = [popup.actionLabels objectAtIndex:0];
        [tryAgainLabal setFont:[UIFont fontWithName:NO_GPS_AVAILABLE_TRY_AGAIN_BUTTON_FONT size:NO_GPS_AVAILABLE_TRY_AGAIN_BUTTON_FONT_SIZE]];

        RSLabel *okLabel = [popup.actionLabels objectAtIndex:1];
        [okLabel setFont:[UIFont fontWithName:NO_GPS_AVAILABLE_OK_BUTTON_BUTTON_FONT size:NO_GPS_AVAILABLE_OK_BUTTON_BUTTON_FONT_SIZE]];

        [popup presentPopupFromPoint:popupPresentationPoint ToPoint:popupPresentationPoint completion:nil];
        self.isPresentingNoGPSPopup = YES;
    }
}

#pragma mark - Keyboard Notificaiton

- (void)keyboardWillDisplay:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    popupPresentationPoint =  CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - keyboardHeight)/2 );
}

- (void)keyboardWillHide:(NSNotification *)notification {
    popupPresentationPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

@end
