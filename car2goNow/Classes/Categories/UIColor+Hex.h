//
//  UIColor+Hex.h
//  RideScout
//
//  Created by Jason Dimitriou on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (instancetype)colorFromHex:(NSString *)hex alpha:(CGFloat)alpha;

@end
