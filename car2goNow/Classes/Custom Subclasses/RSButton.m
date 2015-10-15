//
//  RSButton.m
//  RideScout
//
//  Created by Brady Miller on 3/2/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RSButton.h"
#import "UIView+Extras.h"

@implementation RSButton

#pragma mark - Build Button

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addBorderWithRadius:2.0 andColor:[UIColor whiteColor]];
    [self roundCornersWithRadius:self.frame.size.height / 2];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
}

@end
