//
//  EnterTextPopup.h
//  RideScout
//
//  Created by Jason Dimitriou on 6/22/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <RideKit/RKPinPopup.h>

@interface EnterTextPopup : RKPopup

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *textFieldString;

- (void)setTextFieldText:(NSString *)text;
- (void)setPlaceHolderText:(NSString *)text;
- (void)setKeyboardType:(UIKeyboardType)keyboardType;
- (void)setTextFieldAlignment:(NSTextAlignment)textAlignment;

@end
