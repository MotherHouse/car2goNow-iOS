//
//  UIView+Extras.m
//  RideScout
//
//  Created by Brady Miller on 2/20/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "UIView+Extras.h"

@implementation UIView (Extras)

- (void)roundCornersWithRadius:(CGFloat)radius {
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = radius;
}

- (void)addBorderWithRadius:(CGFloat)width andColor:(UIColor *)color {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)removeBorder {
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

@end
