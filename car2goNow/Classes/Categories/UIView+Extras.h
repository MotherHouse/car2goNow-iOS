//
//  UIView+Extras.h
//  RideScout
//
//  Created by Brady Miller on 2/20/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extras)

- (void)roundCornersWithRadius:(CGFloat)radius;
- (void)addBorderWithRadius:(CGFloat)width andColor:(UIColor *)color;
- (void)removeBorder;

@end
