//
//  BCycleKioskPopup.m
//  RideScout
//
//  Created by Charlie Cliff on 7/14/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "BCycleKioskPopup.h"

#import "constantsAndMacros.h"

#define BCYCLE_KIOSK_POPUP_DEFAULT_HEADER_HEIGHT 20


#define FOOTER_BUTTON_SPACING 30
#define FOOTER_BUTTON_WIDTH self.containerView.frame.size.width / 2

#define TEXT_FIELD_SIDE_LENGTH 50

#define BCYCLE_DOCK_TEXT_FIELD_VERTICAL_OFFSET_FROM_CENTER 10

#define TERMS_AND_CONDITIONS_HEIGHT 20
#define VERTICAL_PAD 10
#define DOCK_VIEW_HEIGHT 60
#define TERMS_VIEW_HEIGHT 26

// Hides the Carret
@interface DockTextField : UITextField<UIKeyInput>

@end

@implementation DockTextField

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

@end

@interface BCycleKioskPopup () <UITextFieldDelegate>

// Terms and Conditions Label
@property (nonatomic, strong) UIView *termsView;

@property (nonatomic, strong) UILabel *termsLabel;

@property (nonatomic, strong) UIView *dockNumberView;
@property (nonatomic, strong) UIImageView *borderView;

@end

@implementation BCycleKioskPopup

@synthesize textField;

#pragma mark - Setup

- (void)buildView {
    [super buildView];
    
    // Resize the ContainerView
    CGFloat totalHeight = 2 * POPUP_DEFAULT_HEADER_HEIGHT + DOCK_VIEW_HEIGHT + TERMS_VIEW_HEIGHT;
    [self.containerView setFrame:CGRectMake((POPUP_DEFAULT_WIDTH)/2, (self.frame.size.height-totalHeight)/2, POPUP_DEFAULT_WIDTH, totalHeight)];
    
    // Add the Separator Views
    [self.headerSeparatorImageView setFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width, POPUP_DEFAULT_SEPEARATOR_WIDTH)];
    [self.headerSeparatorImageView setBackgroundColor:COOPER_GRAY];
    
    self.buttonSeparatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width/2, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, POPUP_DEFAULT_SEPEARATOR_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    [self.buttonSeparatorImageView setBackgroundColor:COOPER_GRAY];
    [self.containerView addSubview:self.buttonSeparatorImageView];

    // Set Up the Buttons
    CGFloat cancelLabelX = (self.containerView.frame.size.width / 4) - FOOTER_BUTTON_WIDTH / 2;
    [self.cancelLabel setFrame:CGRectMake(cancelLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    CGFloat acceptLabelX = (3*self.containerView.frame.size.width / 4) - FOOTER_BUTTON_WIDTH / 2;
    [self.acceptLabel setFrame:CGRectMake(acceptLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    
    [self setUpDockNumberiew];
    [self setUpTermsAndConditionsView];
}

- (void)setUpDockNumberiew {
    self.dockNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width, TEXT_FIELD_SIDE_LENGTH + 2*POPUP_DEFAULT_BORDER_WIDTH)];

    // Set Up the Text Field
    self.textField = [[DockTextField alloc] initWithFrame:CGRectMake( (self.dockNumberView.frame.size.width - TEXT_FIELD_SIDE_LENGTH)/ 2, (self.dockNumberView.frame.size.height - TEXT_FIELD_SIDE_LENGTH)/ 2 - BCYCLE_DOCK_TEXT_FIELD_VERTICAL_OFFSET_FROM_CENTER, TEXT_FIELD_SIDE_LENGTH, TEXT_FIELD_SIDE_LENGTH)];
    [self.textField setDelegate:self];
    [self.textField setPlaceholder:@"- -"];
    [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.textField setFont:[UIFont fontWithName:@"OpenSans-Bold" size:30]];
    [self.textField setTextColor:BCYCLE_DARK_GREY];
    [self.textField setTintColor:BCYCLE_DARK_GREY];
    [self.textField setBackgroundColor:[UIColor whiteColor]];
    self.textField.layer.cornerRadius = POPUP_DEFAULT_ROUNDED_CORNER_RADIUS - 0.5;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.textAlignment = NSTextAlignmentCenter;
    
    [self.textField setLeftView:nil];
    [self.textField setRightView:nil];
    
    // Create the PIN Text Field Border
    self.borderView = [[UIImageView alloc] initWithFrame:CGRectMake(self.textField.frame.origin.x - POPUP_DEFAULT_BORDER_WIDTH, self.textField.frame.origin.y - POPUP_DEFAULT_BORDER_WIDTH, self.textField.frame.size.width + 2*POPUP_DEFAULT_BORDER_WIDTH, self.textField.frame.size.height + 2*POPUP_DEFAULT_BORDER_WIDTH) ];
    [self.borderView setBackgroundColor:COOPER_GRAY];
    CALayer *borderLayer = [self.borderView layer];
    [borderLayer setMasksToBounds:YES];
    
    [self.dockNumberView addSubview:self.borderView];
    [self.dockNumberView addSubview:self.textField];
    [self.containerView addSubview:self.dockNumberView];
}

- (void)setUpTermsAndConditionsView {
    CGFloat termsViewY = POPUP_DEFAULT_HEADER_HEIGHT + DOCK_VIEW_HEIGHT;

    self.termsView = [[UIView alloc] initWithFrame:CGRectMake(0, termsViewY, self.containerView.frame.size.width, TERMS_VIEW_HEIGHT)];

    // Get rid of this
    RSLabel *pricingLabel = [[RSLabel alloc] initWithFrame:CGRectMake(0, self.termsView.frame.origin.y - TERMS_AND_CONDITIONS_HEIGHT * 3 / 4, self.containerView.bounds.size.width, 15)];
    [pricingLabel setText:@"$2 per 30 minutes"];
    [pricingLabel setTextColor:RIDESCOUT_DARK_GREY];
    [self.containerView addSubview:pricingLabel];
    
    CGFloat termsLabelY = (self.termsView.frame.size.height - TERMS_AND_CONDITIONS_HEIGHT) / 2;
    self.termsLabel = [[UILabel alloc] init];
    [self.termsLabel setFrame:CGRectMake(0, termsLabelY, self.containerView.bounds.size.width, TERMS_AND_CONDITIONS_HEIGHT)];
    [self.termsLabel setFont:[UIFont fontWithName:POPUP_DEFAULT_HEADER_FONT_NAME size:PINPOPUP_DEFAULT_ELEMENT_FONT_SIZE]];
    [self.termsLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.termsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.termsLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.termsLabel setNumberOfLines:2];
    [self.termsLabel setText:@"Terms and Conditions"];
    
#pragma warning dont cover up the problem
    UIButton *termsButton = [[UIButton alloc] initWithFrame:self.termsLabel.frame];
    [termsButton addTarget:self action:@selector(termsAndConditionsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //    [self.termsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsAndConditionsButtonPressed)]];
    
    [self.termsView addSubview:termsButton];
    [self.termsView addSubview:self.termsLabel];
    [self.containerView addSubview:self.termsView];
}

#pragma mark - Getters

- (NSString *)getDockNumber {
    return self.textField.text;
}

#pragma mark - Actions

- (void)acceptButtonPressed {
    if ( [[self getDockNumber] length] == 0 ) {
        [self shakeViewFor:0.3];
    }
    else {
        [super acceptButtonPressed];
    }
}

- (void)termsAndConditionsButtonPressed {
    [self.textField resignFirstResponder];
    if (self.termsAndConditionsBlock) {
        self.termsAndConditionsBlock(self);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self.textField becomeFirstResponder];
    if (range.location > 1) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.borderView setBackgroundColor:BCYCLE_LIGHT_PURPLE];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.borderView setBackgroundColor:COOPER_GRAY];
    return YES;
}

#pragma mark - RKPopupDelegate

- (void)closePopup:(RKPopup *)popup {
    [self.textField becomeFirstResponder];
}

@end
