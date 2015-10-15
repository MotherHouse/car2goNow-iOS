//
//  UnlockPopup.h
//  RideScout
//
//  Created by Charlie Cliff on 7/7/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <RideKit/RKPinPopup.h>

@class RSLabel;

@interface UnlockPopup : RKPopup

@property (nonatomic, strong) RSLabel *unlockingLabel;
@property (nonatomic, strong) UIImage *providerIcon;

// The Unlock Icon
@property (nonatomic, strong) UIImage *iconImage;

// This will set the current time on the Countdown Clock
@property (nonatomic) NSInteger countdownTime;

// Display the three View States
- (void)displayLoadingView;
- (void)displaySuccessView;
- (void)displayFailureView;

@end
