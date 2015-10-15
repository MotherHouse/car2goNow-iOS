//
//  MessagePopup.m
//  RideScout
//
//  Created by Jason Dimitriou on 7/27/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "MessagePopup.h"
#import "constantsAndMacros.h"

#define MESSAGE_WIDTH SCREEN_WIDTH*.75
#define MESSAGE_HEIGHT SCREEN_HEIGHT*.22
#define CONTENT_PAD 3
#define EDGE_PAD 12

@interface MessagePopup ()

@property (nonatomic, strong) RSLabel *okLabel;
@property (nonatomic, strong) RSLabel *titleLabel;
@property (nonatomic, strong) RSLabel *subtitleLabel;

@end

@implementation MessagePopup

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        _title = title;
        self.titleLabel.text = title;
        _subtitle = subtitle;
        self.subtitleLabel.text = subtitle;
        [self updateFrames];
    }
    return self;
}

- (void)buildView {
    [super buildView];
    
    CGRect frame = self.containerView.frame;
    [self.containerView setFrame:CGRectMake(frame.origin.x, frame.origin.y, MESSAGE_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT + 2*EDGE_PAD)];
    self.containerView.center = self.center;
    
    // Remove Extraneous Elements
    [self.headerLabel removeFromSuperview];
    self.headerLabel = nil;
    
    self.titleLabel = [[RSLabel alloc]init];
    [self.titleLabel setFontSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setTextColor:BCYCLE_DARK_GREY];
    self.titleLabel.text = self.title;
    [self.containerView addSubview:self.titleLabel];
    
    self.subtitleLabel = [[RSLabel alloc]init];
    [self.subtitleLabel setFontSize:14];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.subtitleLabel setTextColor:BCYCLE_DARK_GREY];
    self.subtitleLabel.text = self.subtitle;
    [self.containerView addSubview:self.subtitleLabel];
    
    self.okLabel = [[RSLabel alloc] init];
    self.okLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.okLabel.textAlignment = NSTextAlignmentCenter;
    [self.okLabel setFontSize:17];
    [self.okLabel setText:@"OK"];
    [self.okLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.okLabel setBackgroundColor:[UIColor clearColor]];
    [self.okLabel setUserInteractionEnabled:YES];
    [self.okLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)]];
    [self.containerView addSubview:self.okLabel];
}

- (void)updateFrames {
    
    CGFloat totalHeight = 0;
    CGFloat textWidth = self.containerView.frame.size.width - 2*EDGE_PAD;
    if (self.title && self.subtitle) {
        // Setup frames if there is both a title and subtitle
        
        // TempView is for vertical sizing Ask Jason
        UITextView *tempView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, textWidth, 10)];
        tempView.text = self.titleLabel.text;
        tempView.font = self.titleLabel.font;
        CGSize titleSize = [tempView sizeThatFits:CGSizeMake(textWidth, CGFLOAT_MAX)];
        
        tempView.text = self.subtitleLabel.text;
        tempView.font = self.subtitleLabel.font;
        CGSize subtitleSize = [tempView sizeThatFits:CGSizeMake(textWidth, CGFLOAT_MAX)];
        totalHeight = titleSize.height + subtitleSize.height + CONTENT_PAD + 2*EDGE_PAD;
        CGFloat x = (self.containerView.frame.size.width - titleSize.width)/2;
        CGFloat y = totalHeight - (titleSize.height + subtitleSize.height + CONTENT_PAD + EDGE_PAD);
        [self.titleLabel setFrame:CGRectMake(x, y, titleSize.width, titleSize.height)];
        x = (self.containerView.frame.size.width - subtitleSize.width)/2;
        y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + CONTENT_PAD;
        [self.subtitleLabel setFrame:CGRectMake(x, y, subtitleSize.width, subtitleSize.height)];
    } else if (self.title || self.subtitle) {
        // Setup frames if there's only either the title or subtitle
        RSLabel *singleLabel = (self.title) ? self.titleLabel : self.subtitleLabel;
        CGSize contentSize = [singleLabel contentSizeForBoundingSize:CGSizeMake(textWidth, SCREEN_HEIGHT)];
        totalHeight = contentSize.height + 2*EDGE_PAD;
        CGFloat x = (self.containerView.frame.size.width - contentSize.width)/2;
        CGFloat y = totalHeight - (contentSize.height - EDGE_PAD);
        [singleLabel setFrame:CGRectMake(x, y, contentSize.width, contentSize.height)];
    }
    
    [self.okLabel setFrame:CGRectMake(0, totalHeight, MESSAGE_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    [self.headerSeparatorImageView setFrame:CGRectMake(0, totalHeight, MESSAGE_WIDTH, 1)];
    
    totalHeight += POPUP_DEFAULT_HEADER_HEIGHT;
    CGRect frame = self.containerView.frame;
    [self.containerView setFrame:CGRectMake(frame.origin.x, frame.origin.y, MESSAGE_WIDTH, totalHeight)];
    self.containerView.center = self.center;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = [title uppercaseString];
    [self updateFrames];
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    self.subtitleLabel.text = subtitle;
    [self updateFrames];
}
@end
