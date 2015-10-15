//
//  BCycleBookingController.m
//  RideScout
//
//  Created by Charlie Cliff on 8/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "BCycleBookingController.h"

#import "Provider.h"
#import "Ride.h"

#import "RSProfileManager.h"
#import "BCycleManager.h"
#import "TripManager.h"
#import "MintManager.h"

#import <RideKit/RideKit.h>
#import "MenuPopup.h"
#import "UnlockPopup.h"
#import "QuestionPopup.h"
#import "BCycleKioskPopup.h"
#import "RSActionSheet.h"
#import "TermsOfServicePopup.h"

#import "constantsAndMacros.h"
#import "messageCopy.h"

typedef NS_ENUM(NSInteger, car2goStateV2){
    bookingMenuPopupState = FIRST_AVAILABLE_BOOKING_STATE,
    bcycleErrorPopupState,
    rideScoutErrorPopupState,
    dockNumberPopupState,
    pinPopupState,
    unlockSuccessPopuState
};

@interface BCycleBookingController()

@property (nonatomic, strong) NSString *dockNumber;
@property (nonatomic, strong) NSString *kioskNumber;

@end

@implementation BCycleBookingController

#pragma mark - Init

- (instancetype)initFromPoint:(CGPoint)point WithPresentngView:(UIView *)view WithProvider:(Provider *)provider{
    self = [super initFromPoint:point WithPresentngView:view WithProvider:provider];
    if ( self != nil) {
        if ( ![RSProfileManager sharedManager].profile.hasDriversLicense || ![RSProfileManager sharedManager].profile.hasCreditCard ) {
            [self setState:incompleteProfilePopupState];
        }
        else
            [self setState:dockNumberPopupState];
    }
    return self;
}

#pragma mark - Presenter State Machine

- (void)presentPopupForCurrentState {
    switch (self.state) {
        case noPinPopupState:
            [super presentIncompletePinPopupFromPoint];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:BOOKING withAction:DISPLAY withMajorUIElement:INCOMPLETE_PIN_POPUP withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        case incompleteProfilePopupState:
            [self presentIncompleteRidersLicenesePopupFromPoint];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:BOOKING withAction:DISPLAY withMajorUIElement:INCOMPLETE_PROFILE_VIEW withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        case bookingMenuPopupState:
            [self presentBCycleMenuPopup];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:BOOKING withAction:DISPLAY withMajorUIElement:BOOKING_MENU withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        case bcycleErrorPopupState:
            [self presentBCycleErrorPopUp];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:DISPLAY withMajorUIElement:BCYCLE_ERROR_POPUP withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        case rideScoutErrorPopupState:
            [self presentRideScoutErrorPopUp];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:DISPLAY withMajorUIElement:RIDESCOUT_ERROR_POPUP withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        case dockNumberPopupState: {
            [self presentBCycleDockNumberPopup];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:^{
                
                [((BCycleKioskPopup *)self.currentPopup).textField becomeFirstResponder];
            }];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:DISPLAY withMajorUIElement:DOCK_POPUP withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        }
//        case pinPopupState:
//            [self presentPinPopup];
//            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
//            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:DISPLAY withMajorUIElement:PIN_POPUP withMinorUIElement:nil withMiscellaneousMessage:nil];
//            break;
        case loadingPopupState:
            [self presentLoadingPopUp];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:DISPLAY withMajorUIElement:LOADING_POPUP withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        case unlockSuccessPopuState:
            [self presentSuccessfulUnlockPopup];
            [self.currentPopup presentPopupFromCenterPoint:self.fromPoint completion:nil];
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:DISPLAY withMajorUIElement:SUCCESS_POPUP withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
        default:
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:BOOKING_MENU withAction:EXIT_FLOW withMajorUIElement:nil withMinorUIElement:nil withMiscellaneousMessage:nil];
            break;
    }
    
}

#pragma mark - Presenting Popups

- (void)presentBCycleMenuPopup {
    
    NSArray *menuButtons = [NSArray arrayWithObjects:BCYCLE_MENU_UNLOCK_BUTTON, nil];
    
    RSActionSheet *bookingMenuSheet = [[RSActionSheet alloc] initWithTitle:nil callback:^(RSActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:BOOKING withAction:PRESSBUTTON withMajorUIElement:BOOKING_MENU withMinorUIElement:CANCEL_BUTTON withMiscellaneousMessage:nil];
            [self setState:exitControlFlowState];
            return;
        }
        
        if (buttonIndex == 0) {
            [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:BOOKING withAction:PRESSBUTTON withMajorUIElement:BOOKING_MENU withMinorUIElement:UNLOCK_BUTTON withMiscellaneousMessage:nil];
            [self setState:dockNumberPopupState];
        }
    } cancelButtonTitle:@"Cancel" otherButtonTitlesArray:menuButtons];
    [bookingMenuSheet showInView:self.presentingView withHorizontalOffset:0];
}

- (void)presentBCycleDockNumberPopup {
    
    self.currentPopup = [[BCycleKioskPopup alloc] initWithFrame:CGRectMake(SCREEN.origin.x, SCREEN.origin.y, SCREEN.size.width - 2*38, SCREEN.size.height)];
    [((BCycleKioskPopup *)self.currentPopup).headerLabel setText:BCYCLE_UNLOCK_DOCK_NUMBER_POPUP_TITLE];
    
    // Set the Acceptance and Cancel Block
    __block __weak __typeof(self)blockSelf = self;
    __weak __typeof(self.currentPopup)weakPopup = self.currentPopup;
    [((BCycleKioskPopup *)self.currentPopup) setAcceptedBlock:^(RKPopup *popup){
        
        [blockSelf setState:loadingPopupState];
        
        [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:PRESSBUTTON withMajorUIElement:DOCK_POPUP withMinorUIElement:OK_BUTTON withMiscellaneousMessage:nil];
        blockSelf.dockNumber = [((BCycleKioskPopup *)weakPopup) getDockNumber];
        blockSelf.kioskNumber = blockSelf.ride.positionId;
        NSString *currentPin = @"WUBALUB A DUB DUB!!!";
        if ( ![RSProfileManager sharedManager].profile.bCycleID  ) {
            [BCycleManager registerBCycleAccountWithSuccess:^{
                // Send the Unlock API Request
                [BCycleManager checkoutBCycleWithDockID:[blockSelf.dockNumber integerValue] withKioskID:[blockSelf.kioskNumber integerValue] withUserPin:currentPin withSuccess:^(Trip *newTrip) {
                    [blockSelf setState:unlockSuccessPopuState];
                    [[LocationManager sharedLocationManager] startCollectingPointsForTrip];
                    [[TripManager sharedTripManager] startTrip:newTrip];
                } WithErrorHandler:^(NSInteger code) {
                    [blockSelf setState:rideScoutErrorPopupState];
                }];
                
            } WithErrorHandler:^(NSInteger code) {
                [blockSelf setState:rideScoutErrorPopupState];
            }];
        }
        else {
            // Send the Unlock API Request
            [BCycleManager checkoutBCycleWithDockID:[blockSelf.dockNumber integerValue]  withKioskID:[blockSelf.kioskNumber integerValue] withUserPin:currentPin withSuccess:^(Trip *newTrip) {
                [blockSelf setState:unlockSuccessPopuState];
                [[TripManager sharedTripManager] startTrip:newTrip];
            } WithErrorHandler:^(NSInteger code) {
                [blockSelf setState:rideScoutErrorPopupState];
            }];
        }
    }];
    [((BCycleKioskPopup *) self.currentPopup) setTermsAndConditionsBlock:^(RKPopup *popup){
        [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:PRESSBUTTON withMajorUIElement:PIN_POPUP withMinorUIElement:TERMS_AND_CONDITIONS_BUTTON withMiscellaneousMessage:nil];        
        CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
        TermsOfServicePopup *tosPopup = [[TermsOfServicePopup alloc] initWithTermsOfServiceURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@providers/bcycle/eula/?api_key=%@&lat=%f&lng=%f", API_URL, API_KEY, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude]]];
        [tosPopup presentPopupFromCenterPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2) completion:nil];
        tosPopup.delegate = (BCycleKioskPopup *)blockSelf.currentPopup;
    }];
    [((BCycleKioskPopup *)self.currentPopup) setCanceledBlock:^(RKPopup *popup){
        [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:PRESSBUTTON withMajorUIElement:DOCK_POPUP withMinorUIElement:CANCEL_BUTTON withMiscellaneousMessage:nil];
        [blockSelf setState:exitControlFlowState];
    }];
}

- (void)presentLoadingPopUp{
    // Instantiate the Loading Popup
    self.currentPopup = [[UnlockPopup alloc] initWithFrame:CGRectMake(SCREEN.origin.x, SCREEN.origin.y, SCREEN.size.width - 2*38, SCREEN.size.height)];
    ((UnlockPopup *)self.currentPopup).iconImage = self.providerIconImage;
    [((UnlockPopup *)self.currentPopup) displayLoadingView];
}

- (void)presentBCycleErrorPopUp{
    self.currentPopup = [[QuestionPopup alloc] init];
    [((QuestionPopup *) self.currentPopup).headerLabel setText:BCYCLE_BCYCLE_FAILURE_ERROR_TITLE];
    [((QuestionPopup *) self.currentPopup) setQuestionText:BCYCLE_BCYCLE_FAILURE_ERROR_MESSAGE];
    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"OK"];
    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:YES];
    __block __typeof(self)blockSelf = self;
    [self.currentPopup setAcceptedBlock:^(RKPopup *popup){
        [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:PRESSBUTTON withMajorUIElement:BCYCLE_ERROR_POPUP withMinorUIElement:OK_BUTTON withMiscellaneousMessage:nil];
        [blockSelf setState:exitControlFlowState];
    }];
}

- (void)presentRideScoutErrorPopUp{
    // Prompt the User to enter his Credit Card or Driver's License
    self.currentPopup = [[QuestionPopup alloc] init];
    [((QuestionPopup *) self.currentPopup).headerLabel setText:BCYCLE_RIDESCOUT_FAILURE_ERROR_TITLE];
    [((QuestionPopup *) self.currentPopup) setQuestionText:[NSString stringWithFormat:BCYCLE_RIDESCOUT_FAILURE_ERROR_MESSAGE,self.dockNumber]];
    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"OK"];
    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:YES];
    __block __typeof(self)blockSelf = self;
    [self.currentPopup setAcceptedBlock:^(RKPopup *popup){
        [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:PRESSBUTTON withMajorUIElement:RIDESCOUT_ERROR_POPUP withMinorUIElement:OK_BUTTON withMiscellaneousMessage:nil];
        [blockSelf setState:exitControlFlowState];
    }];
}

- (void)presentSuccessfulUnlockPopup {
    // Prompt the User to enter his Credit Card or Driver's License
    self.currentPopup = [[QuestionPopup alloc] init];
    [((QuestionPopup *) self.currentPopup).headerLabel setText:BCYCLE_SUCCESS_TITLE];
    [((QuestionPopup *) self.currentPopup) setQuestionText:BCYCLE_SUCCESS_MESSAGE];
    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"OK"];
    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:YES];
    __block __typeof(self)blockSelf = self;
    [self.currentPopup setAcceptedBlock:^(RKPopup *popup){
        [MintManager splunkEventWithProcess:PROCESS_BCYCLE withVersion:@"1" withRSFeature:UNLOCK withAction:PRESSBUTTON withMajorUIElement:SUCCESS_POPUP withMinorUIElement:OK_BUTTON withMiscellaneousMessage:nil];
        [blockSelf setState:exitControlFlowState];
    }];
}

@end
