//
//  OnboardingState.h
//  RideScout
//
//  Created by Charlie Cliff on 5/12/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnboardingContext.h"

typedef NS_ENUM(NSInteger, onboardingState){
    onbInitialiLoading,
    onbWelcome,
    onbUnsupportedCity,
    onbEnterNewEmail,
    onbEnterOldEmail,
    onbInvalidNewEmail,
    onbInvalidOldEmail,
    onbValidateNewPassword,
    onbValidateForgottenPassword,
    onbEnterNewPassword,
    onbEnterOldPassword,
    onbInvalidNewPassword,
    onbInvalidOldPassword,
    onbPleaseResetNewPassword,
    onbPleaseResetOldPassword,
    onbEnterAddress,
    onbScouting,
    onbTutorials,
    onbEnterPhoneNumber,
    onbEnterPIN,
    onbRidersLicense,
};

@class OnboardingContext;

@interface OnboardingState : UIView

@property(nonatomic,assign) onboardingState state;

- (id) advanceWithContext:(OnboardingContext*)context;

@end

#pragma mark - Initial and Loading States

@interface InitialLoadingState : OnboardingState
@end

@interface WelcomeState : OnboardingState
@end

@interface UnsupportedCityState: OnboardingState
@end

#pragma mark - Rider'sLicense

@interface RidersLicenseState : OnboardingState
@end

#pragma mark - Logging In

@interface EnterPhoneNumberState : OnboardingState
@end

@interface EnterTextCodeState : OnboardingState
@end

#pragma mark - Exit Screen States

@interface ScoutingState : OnboardingState
@end