//
//  OnboardingContext.m
//  RideScout
//
//  Created by Charlie Cliff on 5/12/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "OnboardingContext.h"

@implementation OnboardingContext

@synthesize currentAction;

- (OnboardingContext*) init {
    self = [super init];
    if ( self != nil ) {
        self.currentAction = oaNoAction;
        self.emailErrorCode = -10;
        self.setPasswordErrorCode = -10;
        self.getAccessTokenErrorCode = -10;
        self.loginErrorCode = -10;
    }
    return self;
}

@end