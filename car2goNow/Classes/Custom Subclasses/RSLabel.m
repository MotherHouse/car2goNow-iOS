//
//  RSLabel.m
//  RideScout
//
//  Created by Brady Miller on 3/4/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RSLabel.h"
#import "constantsAndMacros.h"

@interface RSLabel ()

@property (nonatomic, readwrite) CGSize contentSize;

@end

@implementation RSLabel 

@synthesize fontSize = _fontSize;
@synthesize softShadow = _softShadow;
@synthesize softShadowSize = _softShadowSize;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.fontName = DEFAULTFONTNAME;
        self.fontSize = DEFAULTFONTSIZE;
        self.textColor = DEFAULTFONTCOLOR;
        [self setFont];
        [self setTextAlignment:self.textAlignment];
        [self setNumberOfLines:0];
    }
    return self;
}

- (instancetype)initWithFontName:(NSString *)fontName {
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.fontName = fontName;
        self.fontSize = DEFAULTFONTSIZE;
        self.textColor = DEFAULTFONTCOLOR;
        [self setFont];
        [self setTextAlignment:self.textAlignment];
        [self setNumberOfLines:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.fontName = DEFAULTFONTNAME;
        self.fontSize = DEFAULTFONTSIZE;
        self.textColor = DEFAULTFONTCOLOR;
        [self setFont];
        [self setTextAlignment:self.textAlignment];
        [self setNumberOfLines:0];
    }
    return self;
}

#pragma mark - Build Label

- (void)drawTextInRect:(CGRect)rect {
    if (self.softShadow) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        CGContextSetShadow(context, CGSizeZero, self.softShadowSize);
        CGContextSetShadowWithColor(context, CGSizeZero, self.softShadowSize, [UIColor blackColor].CGColor);
        
        [super drawTextInRect:rect];
        
        CGContextRestoreGState(context);
    }
    else {
        [super drawTextInRect:rect];
    }
}

#pragma mark - Sizing

- (CGSize)contentSizeForBoundingSize:(CGSize)boundingSize {
    CGSize size;
    
    //Checks if contentsize should be based on attitributed text or regular text
    if (self.text.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineBreakMode = self.lineBreakMode;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = self.textAlignment;
        
        NSDictionary *attributes = @{NSFontAttributeName : self.font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        
        size = [self.text boundingRectWithSize:boundingSize
                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    attributes:attributes
                                       context:nil].size;
        
//        UITextView *view = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, boundingSize.width, 10)];
//        view.text = self.text;
//        view.font = self.font;
//        size = [view sizeThatFits:CGSizeMake(boundingSize.width, boundingSize.height)];
    }
    else {
        size = [self.attributedText boundingRectWithSize:boundingSize
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                 context:nil].size;
        
    }
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return adjustedSize;
}

#pragma mark - Getters and Setters

- (CGFloat)fontSize {
    if (_fontSize == 0.0) {
        _fontSize = 18.0;
    }
    return _fontSize;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self setFont:[UIFont fontWithName:self.fontName size:self.fontSize]];
}

- (void)setSoftShadow:(BOOL)softShadow {
    _softShadow = softShadow;
}

- (void)setFont {
    [self setFont:[UIFont fontWithName:self.fontName size:self.fontSize]];
    [self setTextColor:self.textColor];
}

@end
