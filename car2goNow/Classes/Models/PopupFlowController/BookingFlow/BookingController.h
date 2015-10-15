//
//  BookingController.h
//  RideScout
//
//  Created by Charlie Cliff on 8/7/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIView+Extras.h"

#import <RideKit/RKPinPopup.h>

#define FIRST_AVAILABLE_BOOKING_STATE 6

@class Provider;
@class Ride;

typedef NS_ENUM(NSInteger, bookingState){
    exitControlFlowState = 0,
    noPinPopupState,
    incompleteProfilePopupState,
    loadingPopupState,
    setNewPinSuccess,
    setNewPinFailure
};

@interface BookingController : NSObject

@property (nonatomic) CGPoint fromPoint;
@property (nonatomic, readonly) UIView *presentingView;


@property (nonatomic, readonly) Ride * ride;
@property (nonatomic, readonly) UIImage *providerIconImage;

@property (nonatomic, readonly) NSInteger state;
@property (nonatomic, strong) RKPopup *currentPopup;

- (instancetype)initFromPoint:(CGPoint)point WithPresentngView:(UIView *)view WithProvider:(Provider *)provider;

- (void)initializeState;
- (void)setState:(NSInteger)state;

- (void)presentPopupForCurrentState;
- (void)presentIncompletePinPopupFromPoint;
- (void)presentIncompleteRidersLicenesePopupFromPoint;
- (void)presentNewPinFailurePopup;

@end
