//
//  OnboardingContext.h
//  RideScout
//
//  Created by Charlie Cliff on 5/12/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, onboardingAction){
    oaNoAction = 1,
    oaForgotPasswordButton=2,
    oaBackButton=3,
    oaContinueButton=4,
    oaReEnterFlowFromEmail=5,
    oaReEnterFlowFromLoginLink=6,
};

@interface OnboardingContext : NSObject

@property(nonatomic) BOOL loggedIn;
@property(nonatomic) BOOL onBoardingRan;
@property(nonatomic) BOOL citySupported;

@property(nonatomic) NSInteger currentAction;

@property(nonatomic) NSInteger emailErrorCode;

@property(nonatomic) NSInteger setPasswordErrorCode;
@property(nonatomic) NSInteger getAccessTokenErrorCode;
@property(nonatomic) NSInteger loginErrorCode;

@property(nonatomic) BOOL homeAddressHasBeenEntered;

# pragma mark Onboarding Redux Context FLAGS
@property(nonatomic) BOOL userHasPhoneNumber;
@property(nonatomic) BOOL userHasEnteredValidTextCode;

// Flags that are procced based on the current state of the User's Profile
@property(nonatomic) BOOL userHasRegisteredCreditCard;
@property(nonatomic) BOOL userHadRegisteredDriversLicense;

@end