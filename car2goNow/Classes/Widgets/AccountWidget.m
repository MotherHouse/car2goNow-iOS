//
//  AccountWidget.m
//  RideScout
//
//  Created by Charlie Cliff on 7/21/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "AccountWidget.h"
#import "ProfileCellData.h"
#import "ProfileWidgetCell.h"
#import "constantsAndMacros.h"
#import <RideKit/RideKit.h>
#import "UnlockPopup.h"
#import "QuestionPopup.h"
#import "messageCopy.h"

//#define ADD_PIN_TITLE @"Add PIN"
//#define VERIFY_PIN_ERROR_TITLE @"Could Not Verify Pin!"
//#define SET_PIN_SUCCESS_TITLE @"You have a new PIN!"
//#define SET_PIN_SUCCESS_MESSAGE @"You have successfully set a new PIN."
//#define SET_PIN_FAILURE_TITLE @"Could Not Set Your Pin!"

typedef NS_ENUM(NSInteger, accountWidgetPopup){
    noPopupState = 0,
    verifyPinPopupState,
    enterNewPinPopupState,
    loadingPopupState,
    invalidPinPopupState,
    newPinPopupSuccessState,
    newPinPopupFailureState
};

@interface AccountWidget()

@property (nonatomic, readonly) NSInteger state;
@property (nonatomic, strong) RKPopup *currentPopup;

@end

@implementation AccountWidget

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self!=nil) {
        [self setUpCellData];
    }
    return self;
}

#pragma mark - Setup

- (void)buildView {
    [super buildView];
    self.headerTitle = @"ACCOUNT";
    [self setState:noPopupState];
}

#pragma mark - Data

- (void)setUpCellData {

    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    // Phone Number
    ProfileCellData *phoneNumberData = [[ProfileCellData alloc] init];
    phoneNumberData.titleString = @"Phone Number";
    NSString *detailTitle = [[RKManager sharedService] getProfile].phoneNumber;
    phoneNumberData.detailString = detailTitle;
    phoneNumberData.detailActionable = NO;
    [data addObject:phoneNumberData];
    
    // Email
    NSArray* emailParts = [[[RKManager sharedService] getProfile].email componentsSeparatedByString: @"@"];
    NSString* emailString = [emailParts lastObject];
    if (![emailString isEqualToString:@"ridescoutapp.com"]) {
        ProfileCellData *emailData = [[ProfileCellData alloc] init];
        emailData.titleString = @"Email";
        NSString *detailTitle = [[RKManager sharedService] getProfile].email;
        emailData.detailString = detailTitle;
        emailData.detailActionable = YES;
        [data addObject:emailData];
    }
    
//    // Pin
//    ProfileCellData *pinData = [self setUpPinData];
//    [data addObject:pinData];
    
    self.cellItems = [NSArray arrayWithArray:data];
}

- (ProfileCellData *)setUpPinData {
    // The User has a PIN
    if ( [[RKManager sharedService] getProfile].useHasPin ) {
        ProfileCellData *pinData = [[ProfileCellData alloc] init];
        pinData.titleString = @"PIN";
        pinData.detailString = @"\u25CF \u25CF \u25CF \u25CF";
        pinData.detailActionable = YES;
        return pinData;
    }
    // The User needs to add his Driver's License
    else {
        ProfileCellData *pinData = [[ProfileCellData alloc] init];
        pinData.titleString = ADD_PIN_TITLE;
        pinData.titleActionable = YES;
        return pinData;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileCellData *data = [self.cellItems objectAtIndex:indexPath.row];
    
    // Add Pin 
    if ( [data.titleString isEqualToString:ADD_PIN_TITLE] ) {
        [self setState:enterNewPinPopupState];
    }
    // Replace Pin
    else if ( [data.titleString isEqualToString:PIN_TITLE] ) {
        [self setState:verifyPinPopupState];
    }
}

#pragma mark - Presenter State Machine

- (void)setState:(NSInteger)state {
    _state = state;
    [self.currentPopup closePopupCompletion:nil];
    [self presentPopupForCurrentState];
}

- (void)presentPopupForCurrentState {
    switch (self.state) {
        case noPopupState:
            self.currentPopup = nil;
            break;
        case verifyPinPopupState:
            [self presentVerifyPinPopup];
            break;
        case enterNewPinPopupState:
            [self presentEnterNewPinPopup];
            break;
        case loadingPopupState:
            [self presentLoadingPopup];
            break;
//        case invalidPinPopupState:
//            [self presentInvalidPinPopup];
//            break;
        case newPinPopupSuccessState:
            [self presentNewPinSucccessPopup];
            break;
        case newPinPopupFailureState:
            [self presentNewPinFailurePopup];
            break;
        default:
            self.currentPopup = nil;
            break;
    }
    if ( self.currentPopup != nil) {
        [self.currentPopup presentPopupFromView:self completion:nil];
    }
}

#pragma mark - Popup

- (void)presentVerifyPinPopup {
    self.currentPopup = [RKPinPopup pinPopupWithTitle:RIDERS_PROFILE_VERIFY_PIN_POPUP_TITLE WithMessage:RIDERS_PROFILE_VERIFY_PIN_POPUP_MESSAGE];
        
    __block __weak __typeof(self)blockSelf = self;
    [((RKPinPopup *)self.currentPopup) setPinIsValidBlock:^(RKPopup *popup) {
        [blockSelf setState:enterNewPinPopupState];
    }];
}

- (void)presentEnterNewPinPopup {
    self.currentPopup = [RKPinPopup pinPopupForPinCreation];
    __block __weak __typeof(self)blockSelf = self;
    [((RKPinPopup *)self.currentPopup) setCreatePinSuccessBlock:^(RKPopup *popup) {
        [blockSelf setState:newPinPopupSuccessState];
    }];
    [((RKPinPopup *)self.currentPopup) setCreatePinFailureBlock:^(RKPopup *popup) {
        [blockSelf setState:newPinPopupFailureState];
    }];
}

- (void)presentLoadingPopup {
    self.currentPopup = [[UnlockPopup alloc] init];
    [((UnlockPopup *)self.currentPopup).headerLabel setText:@""];
    [((UnlockPopup *)self.currentPopup) displayLoadingView];
    [((UnlockPopup *)self.currentPopup) presentPopupFromView:self completion:nil];
}

//- (void)presentInvalidPinPopup {
//    // Prompt the User to enter his Credit Card or Driver's License
//    self.currentPopup = [[QuestionPopup alloc] init];
//    [((QuestionPopup *) self.currentPopup).headerLabel setText:VERIFY_PIN_ERROR_TITLE];
//    [((QuestionPopup *) self.currentPopup) setQuestionText:@"Please try re-entering your pin."];
//    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"OK"];
//    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:YES];
//    __block __typeof(self)blockSelf = self;
//    [((QuestionPopup *) self.currentPopup) setCanceledBlock:^(RKPopup *popup) {
//        [blockSelf setState:noPopupState];
//    }];
//}

- (void)presentNewPinSucccessPopup {
    // Prompt the User to enter his Credit Card or Driver's License
    self.currentPopup = [[QuestionPopup alloc] init];
    [((QuestionPopup *) self.currentPopup).headerLabel setText:RIDERS_PROFILE_CHANGE_PIN_SUCCESS_TITLE];
    [((QuestionPopup *) self.currentPopup) setQuestionText:RIDERS_PROFILE_CHANGE_PIN_SUCCESS_MESSAGE];
    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"OK"];
    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:YES];
    __block __typeof(self)blockSelf = self;
    [((QuestionPopup *) self.currentPopup) setCanceledBlock:^(RKPopup *popup) {
        [blockSelf setState:noPopupState];
    }];
}

- (void)presentNewPinFailurePopup {
    // Prompt the User to enter his Credit Card or Driver's License
    self.currentPopup = [[QuestionPopup alloc] init];
    [((QuestionPopup *) self.currentPopup).headerLabel setText:RIDERS_PROFILE_CHANGE_PIN_FAILURE_TITLE];
    [((QuestionPopup *) self.currentPopup) setQuestionText:RIDERS_PROFILE_CHANGE_PIN_FAILURE_MESSAGE];
    [((QuestionPopup *) self.currentPopup) setCancelLabelText:@"OK"];
    [((QuestionPopup *) self.currentPopup) setAcceptanceButtonHidden:YES];
    __block __typeof(self)blockSelf = self;
    [((QuestionPopup *) self.currentPopup) setCanceledBlock:^(RKPopup *popup) {
        [blockSelf setState:noPopupState];
    }];
}
@end
