//
//  UIImage+Circles.h
//  RideScout
//
//  Created by Stuart Carney on 9/18/13.
//  Copyright (c) 2013 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Circles)

+ (UIImage*)circularScaleNCrop:(UIImage*)image scaledToRect:(CGRect)rect;

@end
