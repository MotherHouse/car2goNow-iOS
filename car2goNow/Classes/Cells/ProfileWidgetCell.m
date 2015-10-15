//
//  ProfileWidgetCell.m
//  RideScout
//
//  Created by Jason Dimitriou on 6/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ProfileWidgetCell.h"
#import "constantsAndMacros.h"
#import "RSLabel.h"

//#define ACTIONABLE_COLOR RIDESCOUT_GREEN
#define INDENTATION 10
#define CONTENT_PAD -1
#define ICON_WIDTH 40

@interface ProfileWidgetCell ()

@property (nonatomic, strong) RSLabel *titleLabel;
@property (nonatomic, strong) RSLabel *subTitleLabel;
@property (nonatomic, strong) RSLabel *detailLabel; // POsitioned on the Right_Hand side of the Cell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *separatorLine;

@end

@implementation ProfileWidgetCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor clearColor]];
    
    CGFloat labelX = INDENTATION;
    if (self.cellData.icon) {
        [self.iconImageView setFrame:CGRectMake(0, 0, ICON_WIDTH, self.frame.size.height)];
        self.iconFrame = self.iconImageView.frame;
        labelX = ICON_WIDTH;
    }
    
    // Arrange the Title and Subtitle Labels
    if (self.cellData.titleString && self.cellData.subTitleString) {
        CGSize boundingSize = CGSizeMake(self.frame.size.width, (self.frame.size.width - (labelX + 3*INDENTATION))/2 );
        CGFloat totalContentHeight = [self.titleLabel contentSizeForBoundingSize:boundingSize].height + CONTENT_PAD + [self.subTitleLabel contentSizeForBoundingSize:boundingSize].height;
        CGSize contentSize = [self.titleLabel contentSizeForBoundingSize:boundingSize];
        [self.titleLabel setFrame:CGRectMake(labelX, (self.frame.size.height - totalContentHeight)/2, self.frame.size.width/2 - INDENTATION , contentSize.height)];
        contentSize = [self.subTitleLabel contentSizeForBoundingSize:boundingSize];
        [self.subTitleLabel setFrame:CGRectMake(labelX, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + CONTENT_PAD, contentSize.width, contentSize.height)];
    }
    else if (self.cellData.titleString) {
        CGSize boundingSize = CGSizeMake(self.frame.size.width, (self.frame.size.width - (labelX + 3*INDENTATION))/2 );
        CGSize contentSize = [self.titleLabel contentSizeForBoundingSize:boundingSize];
        [self.titleLabel setFrame:CGRectMake(labelX, (self.frame.size.height - contentSize.height)/2, self.frame.size.width/2 - INDENTATION, contentSize.height)];
    }
    
    // Arrange the Detail Label
    if (self.cellData.detailString) {
        CGRect titleLabelFrame = self.titleLabel.frame;
        CGRect detailLabelFrame = CGRectMake(self.frame.size.width - INDENTATION - titleLabelFrame.size.width, titleLabelFrame.origin.y, titleLabelFrame.size.width, titleLabelFrame.size.height);
        [self.detailLabel setFrame:detailLabelFrame];
        // Not sure if this is necessary
//        [self.detailLabel setBorderColor:[UIColor yellowColor]];
    }

    // Arrange the Separator Line
    if (self.showSeparator) {
        [self.separatorLine setFrame:CGRectMake(INDENTATION, self.frame.size.height-1, self.frame.size.width-INDENTATION, STANDARD_LINE_WEIGHT)];
        [self.separatorLine setBackgroundColor:COOPER_GRAY];
    }
}

#pragma mark - Setters

- (void)setCellData:(ProfileCellData *)cellData {
    _cellData = cellData;
    if (cellData.titleString) {
        self.titleLabel.text = cellData.titleString;
        [self.contentView addSubview:self.titleLabel];
        
    }
    if (cellData.subTitleString) {
        self.subTitleLabel.text = cellData.subTitleString;
        [self.contentView addSubview:self.subTitleLabel];
    }
    if (self.cellData.detailString) {
        self.detailLabel.text = self.cellData.detailString;
        [self.contentView addSubview:self.detailLabel];
    }
    
    // Actionable Elements
    if (self.cellData.titleActionable)
        [self.titleLabel setTextColor:BCYCLE_BLUE];
    else
        [self.titleLabel setTextColor:RIDESCOUT_LIGHT_GREY];
    
    if (self.cellData.subTitleActionable)
        [self.subTitleLabel setTextColor:BCYCLE_BLUE];
    else
        [self.subTitleLabel setTextColor:RIDESCOUT_LIGHT_GREY];
    
    if (self.cellData.detailActionable)
        [self.detailLabel setTextColor:BCYCLE_BLUE];
    else
        [self.detailLabel setTextColor:RIDESCOUT_LIGHT_GREY];
    
    if (cellData.icon) {
        self.iconImageView.image = cellData.icon;
        [self.contentView addSubview:self.iconImageView];
    }
}

- (void)setShowSeparator:(BOOL)showSeparator {
    _showSeparator = showSeparator;
    if (showSeparator) [self.contentView addSubview:self.separatorLine];
    else [self.separatorLine removeFromSuperview];
}

#pragma mark - Getters
- (RSLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[RSLabel alloc] init];
        [_titleLabel setFontSize:DEFAULT_TITLE_FONT_SIZE];
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setOpaque:YES];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        if (self.cellData.titleActionable) [_titleLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    }
    return  _titleLabel;
}

- (RSLabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[RSLabel alloc] init];
        [_subTitleLabel setFontSize:12];
        [_subTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_subTitleLabel setNumberOfLines:0];
        [_subTitleLabel setOpaque:YES];
        [_subTitleLabel setTextAlignment:NSTextAlignmentLeft];
        if (self.cellData.subTitleActionable) [_subTitleLabel setTextColor:BCYCLE_BLUE];
    }
    return  _subTitleLabel;
}

- (RSLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[RSLabel alloc] init];
        [_detailLabel setFontSize:DEFAULT_TITLE_FONT_SIZE];
        [_detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_detailLabel setNumberOfLines:0];
        [_detailLabel setOpaque:YES];
        [_detailLabel setTextAlignment:NSTextAlignmentRight];
        if (self.cellData.detailActionable) [_detailLabel setTextColor:BCYCLE_BLUE];
    }
    return  _detailLabel;
}

- (UIImageView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIImageView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    }
    return _separatorLine;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

@end
