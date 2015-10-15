//
//  BCycleKioskPopup.h
//  RideScout
//
//  Created by Charlie Cliff on 7/14/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "QuestionPopup.h"

@class DockTextField;

@interface BCycleKioskPopup : QuestionPopup <RKPopupDelegate>

@property (nonatomic, strong) void (^termsAndConditionsBlock)(RKPopup *popup);

@property (nonatomic, strong) UITextField *textField;

- (NSString *)getDockNumber;

@end
