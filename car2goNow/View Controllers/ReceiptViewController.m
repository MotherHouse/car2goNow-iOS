//
//  ReceiptViewController.m
//  RideScout
//
//  Created by Charlie Cliff on 8/19/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ReceiptViewController.h"
#import "RSLabel.h"
#import "Receipt.h"
#import "RideIconsManager.h"
#import "TripManager.h"
#import "EmailPopup.h"
#import "messageCopy.h"

#import "RSProfileManager.h"

#import <RideKit/RKRadialGradient.h>

#import "constantsAndMacros.h"

@interface ReceiptViewController ()

// Date
@property (nonatomic, strong) IBOutlet RSLabel *receiptCodeLabel;
@property (nonatomic, strong) IBOutlet RSLabel *dateLabel;

// Total Price
@property (nonatomic, strong) IBOutlet RSLabel *priceLabel;

// The Transaction Deails
@property (nonatomic, strong) IBOutlet UIView *transactionDetailsView;
@property (nonatomic, strong) IBOutlet UIImageView *creditCardIcon;
@property (nonatomic, strong) IBOutlet RSLabel *chargedLabel;
@property (nonatomic, strong) IBOutlet RSLabel *creditCardNumberLabel;

// The Thank You Message
@property (nonatomic, strong) IBOutlet RSLabel *rideScoutDetailLabel;

// Buttons
@property (nonatomic, strong) IBOutlet UIButton *emailReceiptButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

// Background
@property (nonatomic, strong) RKRadialGradient *gradientLayer;
@property (nonatomic, strong) IBOutlet UIView *gradientView;

@property (nonatomic, strong) Receipt *receipt;
@property (nonatomic, strong) EmailPopup *emailPopup;

@end

@implementation ReceiptViewController

#pragma mark - Life Cycle

- (instancetype)initWithReceipt:(Receipt *)receipt {
    self = [super init];
    if (self!=nil) {
        [self setReceipt:receipt];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gradientLayer = [RKRadialGradient new];
    self.gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view.layer addSublayer:self.gradientLayer];
    for (UIView *view in self.view.subviews) [self.view bringSubviewToFront:view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.receiptCodeLabel setText:self.receipt.receiptCode];
    [self.rideScoutDetailLabel setText:RECEIPT_THANK_YOU_TEXT];
    
    // Cost
    NSString *costText = [NSString stringWithFormat:@"$%.2f", [self.receipt.totalCost floatValue]];
    [self.priceLabel setText:costText];
    
    // Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM dd, yyyy";
    NSString *dateText = [dateFormatter stringFromDate:self.receipt.transactionDate];
    [self.dateLabel setText:dateText];
    
    // Credit Card Number
    NSString *lastFourChar = [self.receipt.creditCard.maskedNumber substringFromIndex:[self.receipt.creditCard.maskedNumber length] - 4];
    NSString *expirationStr = self.receipt.creditCard.expirationDateString;
    NSString *creditCardLabelText = [NSString stringWithFormat:@"%@\t%@", lastFourChar, expirationStr];
    [self.creditCardNumberLabel setText:creditCardLabelText];
    
    self.emailReceiptButton.layer.cornerRadius = 5;
}

#pragma mark - Actions

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ( self.closeBlock ) self.closeBlock(self);
    else [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)emailReceiptButtonPressed:(UIButton *)sender {
    self.emailPopup = [[EmailPopup alloc] init];
    
    __block __weak __typeof(self)blockSelf = self;
    [self.emailPopup setAcceptedBlock:^(RKPopup *popup) {
        NSString *email = ((EmailPopup *)popup).emailTextField.text;
        [[RSProfileManager sharedManager] updateProfileEmail:email withSuccess:^{
            [[TripManager sharedTripManager] sendReceipt:blockSelf.receipt toEmail:email];
            [popup closePopupCompletion:nil];
        } failure:^{
            [popup closePopupCompletion:nil];
        }];
    }];
    [self.emailPopup presentPopupFromView:self.view completion:nil];
}

@end
