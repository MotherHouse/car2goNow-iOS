//
//  RSLabel.h
//  RideScout
//
//  Created by Brady Miller on 3/4/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SFREGULAR @"SFUIText-Regular"
#define SFMEDIUM @"SFUIText-Medium"
#define DEFAULTFONTNAME SFREGULAR
#define DEFAULTFONTSIZE 14
#define DEFAULTFONTCOLOR [UIColor whiteColor]

IB_DESIGNABLE
@interface RSLabel : UILabel

@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) BOOL softShadow;
@property (nonatomic, assign) CGFloat softShadowSize;

- (instancetype)initWithFontName:(NSString *)fontName;
- (CGSize)contentSizeForBoundingSize:(CGSize)boundingSize;

@end
