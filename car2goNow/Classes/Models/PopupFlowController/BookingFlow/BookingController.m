//
//  BookingController.m
//  RideScout
//
//  Created by Charlie Cliff on 8/7/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "BookingController.h"
#import "Provider.h"
#import "Ride.h"

#import "MenuPopup.h"
#import "UnlockPopup.h"
#import "QuestionPopup.h"

#import <RideKit/RKPinPopup.h>

#import "constantsAndMacros.h"
#import "messageCopy.h"

@implementation BookingController

#pragma mark - Init

- (instancetype)initFromPoint:(CGPoint)point WithPresentngView:(UIView *)view WithProvider:(Provider *)provider{
    self = [super init];
    if ( self != nil) {
        _fromPoint = point;
        _presentingView = view;
        
        // Set the Provider Variables
        _ride = provider.selectedRide;
        [self setProviderIconURL:provider.iconUrl];
    }
    return self;
}

#pragma mark - Setters

- (void)setProviderIconURL:(NSString *)iconURL {
    _providerIconImage = [[RideIconsManager sharedCache] imageIconForURL:iconURL];
}

#pragma mark - State

- (void)initializeState {
    NSLog(@"You need to define initializeState");
}

- (void)setState:(NSInteger)state {
    _state = state;
    
    // Close Popup
    if ( self.currentPopup != nil ) {
        [self.currentPopup closePopupCompletion:nil];
        self.currentPopup = nil;
    }
    [self presentPopupForCurrentState];
}

- (void)presentPopupForCurrentState {
    self.currentPopup = nil;
}

#pragma mark - Generic Error States

- (void)presentIncompletePinPopupFromPoint {
    self.currentPopup = [RKPinPopup pinPopupForPinCreation];
    
    __block __typeof(self)blockSelf = self;
//    [((RKPinPopup *) self.currentPopup) setPinIsValidBlock:^(RKPopup *popup) {
//        [blockSelf setState:loadingPopupState];
//#warning Charlie
////        NSString *pin = ((RKPinPopup *)popup).pin;
////        [[RKProfileManager sharedProfileManager] updateProfilePIN:pin withSuccess:^{
////            [blockSelf setState:setNewPinSuccess];
////        } failure:^{
////            [blockSelf setState:setNewPinFailure];
////        }];
//    }];
    
    [((RKPinPopup *) self.currentPopup) setCreatePinSuccessBlock:^(RKPopup *popup) {
        [blockSelf setState:setNewPinSuccess];
    }];
    [((RKPinPopup *) self.currentPopup) setCreatePinSuccessBlock:^(RKPopup *popup) {
        [blockSelf setState:setNewPinFailure];
    }];
}

- (void)presentIncompleteRidersLicenesePopupFromPoint {
    // Prompt the User to enter his Credit Card or Driver's License
    self.currentPopup= [[QuestionPopup alloc] init];
    [((QuestionPopup *) self.currentPopup).headerLabel setText:@"Incomplete Profile"];
    [((QuestionPopup *) self.currentPopup) setQuestionText:@"Please provide your credit card and your driver's license."];
    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"Cancel"];
    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:NO];
    [((QuestionPopup *) self.currentPopup) setAcceptLabelText:@"OK"];
    __block __typeof(self)blockSelf = self;
    [((QuestionPopup *) self.currentPopup) setAcceptedBlock:^(RKPopup *popup) {
        [blockSelf setState:exitControlFlowState];
        [blockSelf performSelector:@selector(postRidersLicenseNotification) withObject:nil afterDelay:0.3 inModes:@[NSRunLoopCommonModes]];
    }];
}

- (void)presentNewPinFailurePopup {
    // Prompt the User to enter his Credit Card or Driver's License
    self.currentPopup = [[QuestionPopup alloc] init];
    [((QuestionPopup *) self.currentPopup).headerLabel setText:@"Could Nt set Your PIN!!!!"];
    [((QuestionPopup *) self.currentPopup) setQuestionText:@"OH NOEZ!"];
    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"OK"];
    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:YES];
}

#pragma mark - Notifications

- (void)postRidersLicenseNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_RIDERS_LICENSE_VC_NOTIFICATION object:nil userInfo:nil];
}

@end
