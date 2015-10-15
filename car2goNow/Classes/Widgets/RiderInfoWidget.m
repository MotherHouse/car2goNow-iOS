//
//  RiderInfoWidget.m
//  RideScout
//
//  Created by Jason Dimitriou on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RiderInfoWidget.h"
#import "ProfileCellData.h"
#import "ProfileWidgetCell.h"
#import "EnterTextPopup.h"

#import "RSProfileManager.h"
#import "MintManager.h"

#import "constantsAndMacros.h"
#import "messageCopy.h"

#import "RSProfileManager.h"
#import <RideKit/RideKit.h>
#import <RideKit/NSDictionary+RKParser.h>

@interface RiderInfoWidget()

@property (nonatomic, strong) UIView *incompleteProfileInstructionsView;
@property (nonatomic, strong) RSLabel *incompleteProfileInstrucitonLabel;
@property (nonatomic, strong) RSLabel *incompleteProfileInstructionsButton;
@property (nonatomic, strong) UIImageView *incompleteProfileInstructionsSeparatorView;

@end

@implementation RiderInfoWidget

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCellData];
    }
    return self;
}

#pragma mark - Build

- (void)buildView {    
    if ( ![RSProfileManager sharedManager].profile.hasCreditCard || ![RSProfileManager sharedManager].profile.hasDriversLicense ) {
        [self buildViewForIncompleteProfile];
    }
    else {
        [self buildViewForCompleteProfile];
    }
    [self.tableView reloadData];
    [self updateViewSize];
    self.headerTitle = @"RIDERS PROFILE";
}

- (void)buildViewForIncompleteProfile {
    [super buildView];
    [self buildIncompleteProfileInstructionView];

    if (![RSProfileManager sharedManager].profile.hasCreditCard && ![RSProfileManager sharedManager].profile.hasDriversLicense) {
        [self.incompleteProfileInstructionsButton setHidden:NO];
        [self.incompleteProfileInstructionsButton setUserInteractionEnabled:YES];
    }
    else {
        [self.incompleteProfileInstructionsButton setHidden:YES];
        [self.incompleteProfileInstructionsButton setUserInteractionEnabled:NO];
    }
    
    if (self.tableView.superview == nil)
        [self addSubview:self.tableView];
}

- (void)buildViewForCompleteProfile {
    [super buildView];
}

- (void)buildIncompleteProfileInstructionView {
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, WIDGET_HEADER_HEIGHT + INCOMPLETE_PROFILE_INSTRUCTION_LABEL_HEIGHT + INCOMPLETE_PROFILE_INSTRUCTION_BUTTON_HEIGHT)];
    
    // Incomplete Profile Instructions
    CGFloat widgetWidth = self.frame.size.width;

    if ( self.incompleteProfileInstructionsView == nil ) {
        CGRect instructionFrame = CGRectMake(0, WIDGET_HEADER_HEIGHT, widgetWidth, INCOMPLETE_PROFILE_INSTRUCTION_LABEL_HEIGHT + INCOMPLETE_PROFILE_INSTRUCTION_BUTTON_HEIGHT );
        self.incompleteProfileInstructionsView = [[UIView alloc] initWithFrame:instructionFrame];
        [self.incompleteProfileInstructionsView setUserInteractionEnabled:YES];
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, WIDGET_HEADER_HEIGHT + INCOMPLETE_PROFILE_INSTRUCTION_LABEL_HEIGHT + INCOMPLETE_PROFILE_INSTRUCTION_BUTTON_HEIGHT)];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentRidersLicenseVC)];
        [tapGestureRecognizer setCancelsTouchesInView:NO];;
        [self.incompleteProfileInstructionsView addGestureRecognizer:tapGestureRecognizer];
    }

    if ( self.incompleteProfileInstrucitonLabel == nil ) {
        self.incompleteProfileInstrucitonLabel = [[RSLabel alloc] init];
        CGRect labelFrame = CGRectMake(0, 0, widgetWidth, INCOMPLETE_PROFILE_INSTRUCTION_LABEL_HEIGHT);
        [self.incompleteProfileInstrucitonLabel setFrame:labelFrame];
        [self.incompleteProfileInstrucitonLabel setText:INCOMPLETE_PROFILE_INSTRUCTIONS];
        [self.incompleteProfileInstrucitonLabel setTextColor:BCYCLE_DARK_GREY];
        [self.incompleteProfileInstrucitonLabel setTextAlignment:NSTextAlignmentCenter];
        [self.incompleteProfileInstrucitonLabel setFontSize:INCOMPLETE_PROFILE_INSTRUCTION_LABEL_FONT_SIZE];
        [self.incompleteProfileInstructionsView addSubview:self.incompleteProfileInstrucitonLabel];
    }

    if ( self.incompleteProfileInstructionsButton == nil ) {
        self.incompleteProfileInstructionsButton = [[RSLabel alloc] init];
        CGRect buttonFrame = CGRectMake(0, INCOMPLETE_PROFILE_INSTRUCTION_LABEL_HEIGHT, widgetWidth, INCOMPLETE_PROFILE_INSTRUCTION_BUTTON_HEIGHT);
        [self.incompleteProfileInstructionsButton setFrame:buttonFrame];
        [self.incompleteProfileInstructionsButton setText:@"Complete Profile"];
        [self.incompleteProfileInstructionsButton setTextColor:BCYCLE_BLUE];
        [self.incompleteProfileInstructionsView addSubview:self.incompleteProfileInstructionsButton];
    }
    
    if ( self.incompleteProfileInstructionsSeparatorView == nil ) {
        self.incompleteProfileInstructionsSeparatorView = [[UIImageView alloc] init];
        self.incompleteProfileInstructionsSeparatorView.backgroundColor = COOPER_GRAY;
        [self.incompleteProfileInstructionsSeparatorView setFrame:CGRectMake(INDENTATION, self.incompleteProfileInstructionsView.frame.size.height-1, self.incompleteProfileInstructionsView.frame.size.width-INDENTATION, STANDARD_LINE_WEIGHT)];
        [self.incompleteProfileInstructionsView addSubview:self.incompleteProfileInstructionsSeparatorView];
    }
    
    CGFloat tableViewY = self.incompleteProfileInstructionsView.frame.origin.y + self.incompleteProfileInstructionsView.frame.size.height;
    [self.tableView setFrame:CGRectMake(0, tableViewY, self.tableView.frame.size.width, self.cellItems.count*PROFILE_WIDGET_CELL_HEIGHT)];

    if (self.incompleteProfileInstructionsView.superview == nil) {
        [self addSubview:self.incompleteProfileInstructionsView];
    }
}

#pragma mark - Over Ride the Update

- (void)reload {
    [self.incompleteProfileInstructionsView removeFromSuperview];
    [self.headerLabel removeFromSuperview];
    [self.tableView removeFromSuperview];
    [self setUpCellData];
    [self buildView];
}

#pragma mark - Data

- (void)setUpCellData {
    
    NSMutableArray *data = [[NSMutableArray alloc] init];

        RSProfile *profile = [RSProfileManager sharedManager].profile;
        
        // Credit Card
        ProfileCellData *addCreditCard = [self setUpCreditCardData];
        [data addObject:addCreditCard];
        
        // Driver's License
        ProfileCellData *addDriverLicense = [self setUpDriversLicenseData];
        [data addObject:addDriverLicense];
        
        // Full Name
        ProfileCellData *fullNameDate = [[ProfileCellData alloc] init];
        fullNameDate.titleString = @"Name";
        fullNameDate.detailActionable = NO;
        if (profile.identification.name) {
            fullNameDate.detailString = profile.identification.name;
            fullNameDate.icon = [self circleWithCheckMark];
        } else {
            fullNameDate.icon = [self blankCircle];
        }
        
        [data addObject:fullNameDate];

    self.cellItems = [NSArray arrayWithArray:data];
}

- (ProfileCellData *)setUpDriversLicenseData {
    // The User has loaded his Driver's License
    if ( [[RKManager sharedService] getProfile].identification != nil ) {
        ProfileCellData *addDriverLicenseData = [[ProfileCellData alloc] init];
        addDriverLicenseData.titleString = ADD_DRIVERS_LICENSE_TITLE;
        addDriverLicenseData.titleActionable = NO;
        addDriverLicenseData.detailString = VERIFIED_DRIVERS_LICENSE_TITLE;
        addDriverLicenseData.detailActionable = YES;
        addDriverLicenseData.icon = [self circleWithCheckMark];
        return addDriverLicenseData;
    }
    // The User needs to add his Driver's License
    else {
        ProfileCellData *addDriverLicenseData = [[ProfileCellData alloc] init];
        addDriverLicenseData.titleString = ADD_DRIVERS_LICENSE_TITLE;
        addDriverLicenseData.titleActionable = NO;
        addDriverLicenseData.icon = [self blankCircle];

        return addDriverLicenseData;
    }
}

- (ProfileCellData *)setUpCreditCardData {
    // The User has loaded his default Credit Card
    if ( [[RSProfileManager sharedManager].profile.creditCards count] > 0 ) {
        ProfileCellData *addCreditCardData = [[ProfileCellData alloc] init];
        addCreditCardData.titleString = ADD_CREDIT_CARD_TITLE;
        addCreditCardData.titleActionable = NO;
        
        // Fetch the Credit Card, which should be the only object in our paymenyData Array
        RKCreditCard *firstCreditCard = [[RSProfileManager sharedManager].profile.creditCards firstObject];
        
        // Set up the information for the Credit Card
        NSString *cardType = firstCreditCard.cardType;
        NSString *lastFourDigits = [firstCreditCard.maskedNumber substringFromIndex:[firstCreditCard.maskedNumber length] - 4];
        NSString *creditCardDetailString = [NSString stringWithFormat:@"%@ %@", cardType, lastFourDigits];
        
        addCreditCardData.detailString = creditCardDetailString;
        addCreditCardData.detailActionable = YES;
        
        addCreditCardData.icon = [self circleWithCheckMark];
        return addCreditCardData;
    }
    // The User needs to add his default Credit Card
    else {
        ProfileCellData *addCreditCardData = [[ProfileCellData alloc] init];
        addCreditCardData.titleString = ADD_CREDIT_CARD_TITLE;
        addCreditCardData.titleActionable = NO;
        addCreditCardData.icon = [self blankCircle];
        return addCreditCardData;
    }
}

#pragma mark - Helpers

- (ProfileCellData *)convertCreditCardToCellData:(RKCreditCard *)creditCard {
    // Credit Card Data
    NSString *maskedNumer = creditCard.maskedNumber;
    NSString *nickname = creditCard.nickName;
    
    // Set up the ProfileCellData
    ProfileCellData *data = [[ProfileCellData alloc] init];
    data.titleString = nickname;
    data.titleActionable = NO;
    data.cellActionable = NO;
    data.subTitleActionable= NO;
    data.subTitleString = maskedNumer;
    data.icon = nil;
    return data;
}


- (UIImage *)circleWithCheckMark {
    UIView *compositeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    // Create a Circle
    UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [circle setBackgroundColor:[UIColor clearColor]];
    [circle setAlpha:0.3];
    [circle.layer setCornerRadius:circle.frame.size.width / 2];
    [circle.layer setBorderColor:BCYCLE_BLUE.CGColor];
    [circle.layer setBorderWidth:1.0];
    [compositeView addSubview:circle];
    
    // Check Mark View
    UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CHECKMARK_IMAGE_PATH] ];
    CGFloat scaleValue = 15;
    [checkmark setFrame:CGRectMake(20 - scaleValue, 0, scaleValue, scaleValue)];
    [compositeView addSubview:checkmark];
    
    // Take a Snap-Shot of the UiImageView and convert it to a UIImage
    UIGraphicsBeginImageContextWithOptions(circle.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [compositeView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (UIImage *)blankCircle {
    // Create a Circle
    UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [circle setBackgroundColor:[UIColor clearColor]];
    [circle setAlpha:0.3];
    [circle.layer setCornerRadius:circle.frame.size.width / 2];
    [circle.layer setBorderColor:BCYCLE_BLUE.CGColor];
    [circle.layer setBorderWidth:1.0];
    
    // Take a Snap-Shot of the UiImageView and convert it to a UIImage
    UIGraphicsBeginImageContextWithOptions(circle.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [circle.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCellData *data = [self.cellItems objectAtIndex:indexPath.row];
    if ( [data.titleString isEqualToString:RIDERS_PROFILE_DRIVER_VERIFICATION_TITLE] ) {
        [self presentRidersLicenseVC];
    }
    else if ( [data.titleString isEqualToString:RIDERS_PROFILE_PAYMENT_METHOD_TITLE] ) {
        [self presentRidersLicenseVC];
    }
}

- (void)presentRidersLicenseVC {
    UIViewController *vc = [[RKManager sharedService]  ridersLicenseViewControllerWithCompletionHandler:^(RKOnboardingViewController *vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }];
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [viewController presentViewController:vc animated:YES completion:nil];
}

@end
