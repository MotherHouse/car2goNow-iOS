//
//  UnlockPopup.m
//  RideScout
//
//  Created by Charlie Cliff on 7/7/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "UnlockPopup.h"

#import "UIImage+Circles.h"
#import <RideKit/UIImageView+RKRotate.h>
#import <RideKit/UIImage+RKExtras.h>

#import "RSLabel.h"
#import "FLAnimatedImage.h"

#import "AppDelegate.h"
#import "constantsAndMacros.h"

#define CIRCLE_MARGIN 50

#define CIRCLE_IMAGE_FILE @"loadingIndicator.png"
#define UNLOCKING_HEADER_TEXT @"Unlocking In..."

@interface UnlockPopup ()

@property (nonatomic) CGFloat circleWidth;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *loadingImageView;

@property (nonatomic, strong) RSLabel *cancelLabel;

@end

@implementation UnlockPopup

@synthesize loadingImageView;

#pragma mark - Setup

- (void)buildView {
    [super buildView];
    
    // Calculate the Circle Width Dynamically
    self.circleWidth = 80;
    
    // Resize the ContainerView
    [self.containerView setFrame:CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y, self.containerView.frame.size.width, self.containerView.frame.size.height + POPUP_DEFAULT_HEADER_HEIGHT + self.circleWidth + CIRCLE_MARGIN)];
    
    // Remove Extraneous Elements
    [self.headerLabel removeFromSuperview];
    [self.headerSeparatorImageView removeFromSuperview];
    
    // Set Up a Unlock Label
//    self.unlockingLabel = [[RSLabel alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width, POPUP_DEFAULT_HEADER_HEIGHT)];
//    self.unlockingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    self.unlockingLabel.textAlignment = NSTextAlignmentCenter;
//    [self.unlockingLabel setFontSize:17];
//    [self.unlockingLabel setText:@"Unlocking ..."];
//    [self.unlockingLabel setUserInteractionEnabled:YES];
//    [self.containerView addSubview:self.unlockingLabel];

    // Re-Center the Container View
    [self.containerView setBackgroundColor:[UIColor clearColor]];
    self.containerView.center = self.center;
}

#pragma mark - Display the View States

- (void)displayLoadingView {
    // The Loading Animation
    if (self.loadingImageView == nil) {
        CGFloat gap = 8;
        UIImage *loadingImage = [UIImage imageWithImage:[UIImage imageNamed:@"loadingIndicator_book.png"] scaledToSize:CGSizeMake(self.circleWidth+gap, self.circleWidth+gap)];
        self.loadingImageView = [[UIImageView alloc] initWithImage:loadingImage];
        [self.loadingImageView setCenter:CGPointMake(self.containerView.frame.size.width / 2, self.containerView.frame.size.height / 2)];
        [self.loadingImageView rotate360WithDuration:1.5 repeatCount:0];
    }
    
    // The Icon 
    if (self.iconImage) {
        UIImage *unlockIcon = [UIImage imageWithImage:self.iconImage scaledToSize:CGSizeMake(self.circleWidth, self.circleWidth)];
        self.iconImageView = [[UIImageView alloc] initWithImage:unlockIcon];
        [self.iconImageView setCenter:CGPointMake(self.containerView.frame.size.width / 2, self.containerView.frame.size.height / 2)];
        [self.iconImageView setContentMode:UIViewContentModeCenter];
        [self.containerView addSubview:self.iconImageView];
    }
    
    // Display the Loading Icon
    [self.containerView addSubview:self.loadingImageView];
}

- (void)displaySuccessView {
    // Remove the Other Views
    [self.loadingImageView removeFromSuperview];
    [self.unlockingLabel removeFromSuperview];
    
    // Display the Result Image, and modify based on Unlock Result
    self.iconImageView = nil;
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CIRCLE_MARGIN, POPUP_DEFAULT_HEADER_HEIGHT + (CIRCLE_MARGIN/2), self.circleWidth, self.circleWidth)];
    self.iconImageView.backgroundColor = [UIColor greenColor];
    
    // Header Label
    [self.headerLabel setText:@"Unlocked!"];
    [self.containerView addSubview:self.headerLabel];

    // Separator View
    [self.headerSeparatorImageView setFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.headerSeparatorImageView.frame.size.width, self.headerSeparatorImageView.frame.size.height)];
    [self.containerView addSubview:self.headerLabel];
    
    // Add the Cancel Button
    self.cancelLabel = [[RSLabel alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width, POPUP_DEFAULT_HEADER_HEIGHT)];
    self.cancelLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelLabel setFontSize:17];
    [self.cancelLabel setText:@"OK"];
    [self.cancelLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.cancelLabel setBackgroundColor:[UIColor clearColor]];
    [self.cancelLabel setUserInteractionEnabled:YES];
    [self.cancelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)]];
    [self.containerView addSubview:self.cancelLabel];
    
    [self.containerView setBackgroundColor:RIDESCOUT_WHITE];
}

- (void)displayFailureView {
    // Remove the Other Views
    [self.loadingImageView removeFromSuperview];
    [self.unlockingLabel removeFromSuperview];
    
    // Display the Result Image, and modify based on Unlock Result
    self.iconImageView = nil;
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width, POPUP_DEFAULT_HEADER_HEIGHT)];
    self.iconImageView.backgroundColor = [UIColor redColor];
    
    // Header Label
    [self.headerLabel setText:@"Failed to Unlock!"];
    [self.containerView addSubview:self.headerLabel];

    // Separator View
    [self.headerSeparatorImageView setFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.headerSeparatorImageView.frame.size.width, self.headerSeparatorImageView.frame.size.height)];
    [self.containerView addSubview:self.headerSeparatorImageView];
    
    // Add the Cancel Button
    self.cancelLabel = [[RSLabel alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width, POPUP_DEFAULT_HEADER_HEIGHT)];
    self.cancelLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelLabel setFontSize:17];
    [self.cancelLabel setText:@"OK"];
    [self.cancelLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.cancelLabel setBackgroundColor:[UIColor clearColor]];
    [self.cancelLabel setUserInteractionEnabled:YES];
    [self.cancelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)]];
    [self.containerView addSubview:self.cancelLabel];
    
    [self.containerView setBackgroundColor:RIDESCOUT_WHITE];
}

@end
