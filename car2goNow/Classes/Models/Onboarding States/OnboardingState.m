//
//  OnboardingState.m
//  RideScout
//
//  Created by Charlie Cliff on 5/12/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "OnboardingState.h"

@implementation OnboardingState

- (id) advanceWithContext:(OnboardingContext*)context {
    return self;
}

@end

#pragma mark - Logging In

@implementation EnterPhoneNumberState : OnboardingState
- (id) init {
    self = [super init];
    if ( self != nil) {
        self.state = onbEnterPhoneNumber;
    }
    return self;
}
- (id) advanceWithContext:(OnboardingContext *)context {
    if ( context.userHasPhoneNumber ) {
        EnterTextCodeState *nextState = [[EnterTextCodeState alloc] init];
        return nextState;
    }
    return self;
}
@end

@implementation EnterTextCodeState : OnboardingState
- (id) init {
    self = [super init];
    if ( self != nil) {
        self.state = onbEnterPIN;
    }
    return self;
}
- (id) advanceWithContext:(OnboardingContext *)context {
    
    if ( context.userHadRegisteredDriversLicense && context.userHasRegisteredCreditCard ) {
        ScoutingState *nextState = [[ScoutingState alloc] init];
        return nextState;
    }
    RidersLicenseState *nextState = [[RidersLicenseState alloc] init];
    return nextState;
}
@end

#pragma mark - Rider'sLicense

@implementation RidersLicenseState : OnboardingState
- (id) init {
    self = [super init];
    if ( self != nil) {
        self.state = onbRidersLicense;
    }
    return self;
}
- (id) advanceWithContext:(OnboardingContext *)context {
    ScoutingState *nextState = [[ScoutingState alloc] init];
    return nextState;
}
@end

#pragma mark - Exit State

@implementation ScoutingState : OnboardingState
- (id) init {
    self = [super init];
    if ( self != nil) {
        self.state = onbScouting;
    }
    return self;
}
@end

#pragma mark - Error States

@implementation UnsupportedCityState : OnboardingState
- (id) init {
    self = [super init];
    if ( self != nil) {
        self.state = onbUnsupportedCity;
    }
    return self;
}
- (id) advanceWithContext:(OnboardingContext*)context {
    return self;
}
@end