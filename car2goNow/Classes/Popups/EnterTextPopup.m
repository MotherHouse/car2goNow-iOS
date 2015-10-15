//
//  EnterTextPopup.m
//  RideScout
//
//  Created by Jason Dimitriou on 6/22/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "EnterTextPopup.h"
#import "constantsAndMacros.h"
#import "MintManager.h"

#define TEXTFIELD_HEIGHT 30.0
#define ENTER_TEXT_POPUP_WIDTH SCREEN_WIDTH*.8
#define ENTER_TEXT_POPUP_HEIGHT 60.0
#define EDGE_PAD 15

@implementation EnterTextPopup {
    CGFloat keyboardHeight;
    BOOL keyboardShown;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)buildView {
    [super buildView];
    
    CGFloat totalHeight = POPUP_DEFAULT_HEADER_HEIGHT + ENTER_TEXT_POPUP_HEIGHT;
    [self.containerView setFrame:CGRectMake((self.frame.size.width-ENTER_TEXT_POPUP_WIDTH)/2, (self.frame.size.height-totalHeight)/2, ENTER_TEXT_POPUP_WIDTH, totalHeight)];
    self.containerView.clipsToBounds = YES;
    
    [super updateHeaderLayout];
    
    // So we know the exact height of the keyboard instead of hard coding it
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(EDGE_PAD, POPUP_DEFAULT_HEADER_HEIGHT + (ENTER_TEXT_POPUP_HEIGHT-TEXTFIELD_HEIGHT)/2, self.containerView.bounds.size.width - 2*EDGE_PAD, TEXTFIELD_HEIGHT)];
    [self.textField setFont:[UIFont fontWithName:@"OpenSans-Light" size:14]];
    [self.textField setTextColor:BCYCLE_DARK_GREY];
    [self.textField setTintColor:BCYCLE_DARK_GREY];
    [self.textField setBackgroundColor:[UIColor colorWithWhite:1 alpha:.4]];
    self.textField.layer.cornerRadius = 3.0;
    self.textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    [self.containerView addSubview:self.textField];
    
    [MintManager splunkWithString:(POPUP_SCREEN_SHOWN @" - Enter Text") event:YES breadcrumb:YES];
}

- (void)keyboardOnScreen:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self convertRect:rawFrame fromView:nil];
    
    keyboardHeight = keyboardFrame.size.height;
    keyboardShown = ([notification.name isEqualToString:UIKeyboardWillShowNotification]);
    
    [self moveContainerViewForKeyboardUp:keyboardShown];
}

- (void)moveContainerViewForKeyboardUp:(BOOL)up {
    CGRect frame = self.containerView.frame;
    if (up) {
        CGFloat viewHeight = self.containerView.frame.origin.y + self.containerView.frame.size.height;
        CGFloat heightBelowKeyboard = viewHeight - (SCREEN_HEIGHT - keyboardHeight);
        if (heightBelowKeyboard > 0) {
            [UIView animateWithDuration:.3 animations:^{
                [self.containerView setFrame:CGRectMake(frame.origin.x, frame.origin.y - heightBelowKeyboard, frame.size.width, frame.size.height)];
            }];
        }
    }
    else if ((self.frame.size.height - frame.size.height)/2 != frame.origin.y) {
        [UIView animateWithDuration:.3 animations:^{
            [self.containerView setFrame:CGRectMake(frame.origin.x, (self.frame.size.height - frame.size.height)/2, frame.size.width, frame.size.height)];
        }];
    }

}

#pragma mark - Setters

- (void)setPlaceHolderText:(NSString *)text {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:.8], NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Light" size:14]}];
    self.textField.attributedPlaceholder = str;
}

- (void)setTextFieldText:(NSString *)text {
    self.textField.text = text;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.textField.keyboardType = keyboardType;
}

- (void)setTextFieldAlignment:(NSTextAlignment)textAlignment {
    self.textField.textAlignment = textAlignment;
}

#pragma mark - Actions

- (void)acceptButtonPressed {
    NSString *mintString = [NSString stringWithFormat:(POPUP_BUTTON_PRESS @" - Enter Text %@"), self.textField.text];
    [MintManager splunkWithString:mintString event:YES breadcrumb:YES];
    self.textFieldString = self.textField.text;
    [super acceptButtonPressed];
}

- (void)cancelButtonPressed {
    [MintManager splunkWithString:(POPUP_BUTTON_PRESS @" - Close") event:YES breadcrumb:YES];
    [super cancelButtonPressed];
}

@end
