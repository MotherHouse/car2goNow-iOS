//
//  UIColor+Hex.m
//  RideScout
//
//  Created by Jason Dimitriou on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (instancetype)colorFromHex:(NSString *)hex alpha:(CGFloat)alpha {
    uint value = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&value];
    return [UIColor colorWithRed:((value >> 16) & 255) / 255.0f
                           green:((value >> 8) & 255) / 255.0f
                            blue:(value & 255) / 255.0f
                           alpha:alpha];
}

@end
