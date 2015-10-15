//
//  UILabel+Circle.m
//  RideScout
//
//  Created by Jason Dimitriou on 4/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "UILabel+Circle.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (Circle)

- (void)setCircleBackgroundWithColor:(UIColor *)bg {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.backgroundColor = bg.CGColor;
}


@end
