//
//  EmailPopup.m
//  Bcycle
//
//  Created by Charlie Cliff on 9/30/15.
//  Copyright © 2015 ridescout. All rights reserved.
//

#import "EmailPopup.h"
#import "RSLabel.h"
#import "constantsAndMacros.h"
#import "messageCopy.h"

#define DEFAULT_TEXTFIELD_HEIGHT 30.0
#define DEFAULT_ENTER_TEXT_POPUP_WIDTH SCREEN_WIDTH*.8
#define DEFAULT_ENTER_TEXT_POPUP_HEIGHT 60.0
#define EDGE_PAD 15

#define DEFAULT_FOOTER_BUTTON_SPACING 20
#define DEFAULT_FOOTER_BUTTON_WIDTH 60

#define SEPARATOR_WIDTH 0.5

@implementation EmailPopup


#pragma mark - Setup

- (void)buildView {
    [super buildView];
    
    CGFloat totalHeight = POPUP_DEFAULT_HEADER_HEIGHT + DEFAULT_ENTER_TEXT_POPUP_HEIGHT + POPUP_DEFAULT_HEADER_HEIGHT;
    [self.containerView setFrame:CGRectMake((self.frame.size.width-DEFAULT_ENTER_TEXT_POPUP_WIDTH)/2, (self.frame.size.height-totalHeight)/2, DEFAULT_ENTER_TEXT_POPUP_WIDTH, totalHeight)];
    self.containerView.clipsToBounds = YES;
    
    [super updateHeaderLayout];
    [self.headerLabel setText:RECEIPT_EMAIL_POPUP_TITLE];
    self.buttonSeparatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width/2, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, POPUP_DEFAULT_LINE_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    [self.buttonSeparatorImageView setBackgroundColor:COOPER_GRAY];
    [self.containerView addSubview:self.buttonSeparatorImageView];
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(EDGE_PAD, POPUP_DEFAULT_HEADER_HEIGHT + (DEFAULT_ENTER_TEXT_POPUP_HEIGHT - DEFAULT_TEXTFIELD_HEIGHT)/2, self.containerView.bounds.size.width - 2*EDGE_PAD, DEFAULT_TEXTFIELD_HEIGHT)];
    [self.emailTextField setFont:[UIFont fontWithName:@"OpenSans-Light" size:14]];
    [self.emailTextField setTextColor:BCYCLE_DARK_GREY];
    [self.emailTextField setTintColor:BCYCLE_DARK_GREY];
    [self.emailTextField setBackgroundColor:[UIColor whiteColor]];
    self.emailTextField.layer.cornerRadius = 3.0;
    self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    [self.containerView addSubview:self.emailTextField];
    
    // Set Up Cancel Button
    CGFloat cancelLabelX = (self.containerView.frame.size.width / 4) - DEFAULT_FOOTER_BUTTON_WIDTH / 2;
    self.cancelLabel = [[RSLabel alloc] initWithFrame:CGRectMake(cancelLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, DEFAULT_FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    self.cancelLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelLabel setFontSize:17];
    [self.cancelLabel setText:@"Cancel"];
    [self.cancelLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.cancelLabel setBackgroundColor:[UIColor clearColor]];
    [self.cancelLabel setUserInteractionEnabled:YES];
    [self.cancelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)]];
    [self.containerView addSubview:self.cancelLabel];
    
    // Set Up Accept Button
    CGFloat acceptLabelX = (3*self.containerView.frame.size.width / 4) - DEFAULT_FOOTER_BUTTON_WIDTH / 2;
    self.acceptLabel = [[RSLabel alloc] initWithFrame:CGRectMake(acceptLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, DEFAULT_FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    self.acceptLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.acceptLabel.textAlignment = NSTextAlignmentCenter;
    [self.acceptLabel setFontSize:17];
    [self.acceptLabel setText:@"OK"];
    [self.acceptLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.acceptLabel setBackgroundColor:[UIColor clearColor]];
    [self.acceptLabel setUserInteractionEnabled:YES];
    [self.acceptLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptButtonPressed)]];
    [self.containerView addSubview:self.acceptLabel];
    
    UIImageView *buttonTopLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width, SEPARATOR_WIDTH)];
    [buttonTopLineView setBackgroundColor:COOPER_GRAY];
    [self.containerView addSubview:buttonTopLineView];
    
    UIImageView *buttonSeparatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width/2, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, SEPARATOR_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    [buttonSeparatorImageView setBackgroundColor:COOPER_GRAY];
    [self.containerView addSubview:buttonSeparatorImageView];
    
}

#pragma mark - LifeCycle

- (void)didMoveToSuperview {
    [self.emailTextField  performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:APPEARANCE_ANIMATION_DURATION];
}

@end
