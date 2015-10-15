//
//  RiderInfoWidget.h
//  RideScout
//
//  Created by Jason Dimitriou on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ProfileWidget.h"

#define ADD_DRIVERS_LICENSE_TITLE @"Driver Verification"
#define VERIFIED_DRIVERS_LICENSE_TITLE @"Verified"
#define ADD_CREDIT_CARD_TITLE @"Payment Method"
#define CHECKMARK_IMAGE_PATH @"RideKit.bundle/onboarding_check.png"

#define INCOMPLETE_PROFILE_INSTRUCTION_LABEL_HEIGHT 44.0
#define INCOMPLETE_PROFILE_INSTRUCTION_BUTTON_HEIGHT 20.0

#define INCOMPLETE_PROFILE_INSTRUCTION_LABEL_FONT_SIZE 14.0
#define INCOMPLETE_PROFILE_INSTRUCTION_BUTTON_FONT_SIZE 14.0

@interface RiderInfoWidget : ProfileWidget <UITextFieldDelegate>

@end
