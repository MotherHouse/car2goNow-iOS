
//  DirectionCell.m
//  RideScout
//
//  Created by Jason Dimitriou on 3/5/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "DirectionCell.h"
#import "constantsAndMacros.h"
#import <RideKit/UIImage+RKExtras.h>
#import "UIImage+Circles.h"
#import "RSLabel.h"

@interface DirectionCell ()

@property (nonatomic, strong) RSLabel *instructionsLabel;
@property (nonatomic, strong) RSLabel *distanceLabel;
@property (nonatomic, strong) UIImageView *directionImageView;
@property (nonatomic, strong) UIImageView *directionBackgroundCircle;
@property (nonatomic, strong) UIImageView *prevVerticalLine;
@property (nonatomic, strong) UIImageView *verticalLine;
@property (nonatomic, strong) UIImageView *separatorLine;

#define IMAGE_SIZE 15
#define EDGE_PAD 20
#define DIRECTION_MODE_WIDTH 80
#define DISTANCE_TIME_WIDTH 45

#define CONTENT_WIDTH SCREEN_WIDTH - DIRECTION_MODE_WIDTH - EDGE_PAD
#define CONTENTINDENTION 10

@end

@implementation DirectionCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.backgroundColor = [UIColor clearColor];
    [self.directionBackgroundCircle removeFromSuperview];
    [self.verticalLine removeFromSuperview];
    
    CGFloat cellWidth = self.frame.size.width;
    CGSize constraintSize = CGSizeMake(DISTANCE_TIME_WIDTH, MAXFLOAT);
    CGSize contentSize;
    CGFloat contentX, contentY, contentWidth, contentHeight;
    
    CGFloat estimatedHeight = self.frame.size.height;
    
    contentSize = [self.distanceLabel contentSizeForBoundingSize:constraintSize];
    contentX = (DISTANCE_TIME_WIDTH - contentSize.width)/2 + DIRECTION_MODE_WIDTH;
    contentY = estimatedHeight - contentSize.height;
    [self.distanceLabel setFrame:CGRectMake(contentX, contentY, contentSize.width, contentSize.height)];
    
    contentX = DIRECTION_MODE_WIDTH + DISTANCE_TIME_WIDTH;
    contentY = self.distanceLabel.frame.origin.y + (self.distanceLabel.frame.size.height/2);
    contentWidth = cellWidth - contentX;
    
    if (!self.finalStep) {
        [self.separatorLine setFrame:CGRectMake(contentX, contentY, contentWidth, 1)];
    }
    
    constraintSize = CGSizeMake(CONTENT_WIDTH, MAXFLOAT);
    contentSize = [self.instructionsLabel contentSizeForBoundingSize:constraintSize];
    contentY = EDGE_PAD;
    contentX = DIRECTION_MODE_WIDTH;
    [self.instructionsLabel setFrame:CGRectMake(contentX, contentY, contentSize.width, contentSize.height)];
    
    contentX = DIRECTION_MODE_WIDTH/2;
    contentY = EDGE_PAD + contentSize.height/2;
    self.directionImageView.center = CGPointMake(contentX, contentY);
    
    if (self.direction.imageNeedsBackground) {
        UIColor *color = BCYCLE_BLUE;
        self.directionBackgroundCircle = [self getCircleWithDiameter:IMAGE_SIZE andColor:color andCenter:self.directionImageView.center];
        [self addSubview:self.directionBackgroundCircle];
        [self.contentView insertSubview:self.directionBackgroundCircle belowSubview:self.directionImageView];
    }
    
    contentWidth = 2;
    contentX = (DIRECTION_MODE_WIDTH - contentWidth)/2;
    CGPoint centerPoint = self.directionImageView.center;
    if (self.firstStep) {
        contentHeight = estimatedHeight - centerPoint.y;
        contentY = centerPoint.y;
        [self.verticalLine setFrame:CGRectMake(contentX, contentY, contentWidth, contentHeight)];
        [self.contentView addSubview:self.verticalLine];
        [self.contentView sendSubviewToBack:self.verticalLine];
    }
    else if (self.finalStep) {
        contentHeight = centerPoint.y;
        contentY = 0;
        [self.prevVerticalLine setFrame:CGRectMake(contentX, contentY, contentWidth, contentHeight)];
        [self.contentView addSubview:self.prevVerticalLine];
        [self.contentView sendSubviewToBack:self.prevVerticalLine];
    } else {
        contentHeight = centerPoint.y;
        contentY = 0;
        [self.prevVerticalLine setFrame:CGRectMake(contentX, contentY, contentWidth, contentHeight)];
        [self.contentView addSubview:self.prevVerticalLine];
        [self.contentView sendSubviewToBack:self.prevVerticalLine];
        
        contentHeight = estimatedHeight - centerPoint.y;
        contentY = centerPoint.y;
        [self.verticalLine setFrame:CGRectMake(contentX, contentY, contentWidth, contentHeight)];
        [self.contentView addSubview:self.verticalLine];
        [self.contentView sendSubviewToBack:self.verticalLine];
    }
    
    [_instructionsLabel setTextAlignment:NSTextAlignmentLeft];
}

- (void)setupDirectionUI {
    //Reset so the getters set the correct font based on self.starStep and self.finalStep
    self.instructionsLabel = nil;
    self.distanceLabel = nil;
    self.directionImageView = nil;
    self.directionBackgroundCircle = nil;
    self.prevVerticalLine = nil;
    self.verticalLine = nil;
    self.separatorLine = nil;
    
    if (self.direction.titleInstruction) {
        self.instructionsLabel.text = self.direction.titleInstruction;
    }
    else {
        self.instructionsLabel.text = self.direction.instruction;
    }
    [self.contentView addSubview:self.instructionsLabel];
    
    self.distanceLabel.text = self.direction.distanceString;
    [self.contentView addSubview:self.distanceLabel];
    
    [self.contentView addSubview:self.directionImageView];
    
    //Should already have the image in it from the getter
    [self.contentView addSubview:self.prevVerticalLine];
    [self.contentView addSubview:self.verticalLine];
    [self.contentView addSubview:self.separatorLine];
}

#pragma mark - Cell Height

- (CGFloat)cellHeight {
    return MAX([self getContentLabelsHeight], DIRECTION_CELL_HEIGHT);
}

- (CGFloat)getContentLabelsHeight {
    CGSize constraintSize = CGSizeMake(CONTENT_WIDTH, MAXFLOAT);
    CGSize contentSize;
    CGFloat totalHeight = EDGE_PAD;
    
    contentSize = [self.instructionsLabel contentSizeForBoundingSize:constraintSize];
    totalHeight += contentSize.height + EDGE_PAD;
    
    contentSize = [self.distanceLabel contentSizeForBoundingSize:constraintSize];
    totalHeight += contentSize.height;
    
    return totalHeight;
}

#pragma mark - Setters

- (void)setDirection:(Direction *)direction {
    if (!direction) return;
    
    _direction = direction;
    
    [self setupDirectionUI];
    [self layoutSubviews];
}

#pragma mark - Getters

- (RSLabel *)instructionsLabel {
    if (!_instructionsLabel) {
        _instructionsLabel = [[RSLabel alloc] init];
        [_instructionsLabel setFontSize:18];
        [_instructionsLabel setTextColor:BCYCLE_DARK_GREY];
        [_instructionsLabel setTextColor:[UIColor blackColor]];
        [_instructionsLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_instructionsLabel setNumberOfLines:0];
        [_instructionsLabel setOpaque:YES];
        [_instructionsLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return  _instructionsLabel;
}

- (RSLabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[RSLabel alloc] init];
        [_distanceLabel setFontSize:12];
        [_distanceLabel setTextColor:RIDESCOUT_LIGHT_GREY];
    }
    return  _distanceLabel;
}

- (UIImageView *)directionImageView {
    if (!_directionImageView) {
        if (_direction.image) _directionImageView = [[UIImageView alloc] initWithImage:_direction.image];
        else _directionImageView = [self getCircleWithDiameter:IMAGE_SIZE - 4 andColor:BCYCLE_LIGHT_PURPLE andCenter:CGPointMake(0, 0)];
    }
    return _directionImageView;
}

- (UIImageView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [[UIImageView alloc] init];
        _verticalLine.backgroundColor = _direction.polylineColor;
    }
    return _verticalLine;
}

- (UIImageView *)prevVerticalLine {
    if (!_prevVerticalLine) {
        _prevVerticalLine = [[UIImageView alloc] init];
        _prevVerticalLine.backgroundColor = _prevCellLineColor;
    }
    return _prevVerticalLine;
}

- (UIImageView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIImageView alloc] init];
        _separatorLine.backgroundColor = BCYCLE_LIGHT_GREY;
    }
    return _separatorLine;
}

#pragma mark - Helpers

- (UIImageView *)getCircleWithDiameter:(CGFloat)diameter andColor:(UIColor*)color andCenter: (CGPoint)center {
    CGSize circleSize = CGSizeMake(diameter, diameter);
    UIImage *circleImage = [UIImage imageWithColor:color size:circleSize];
    CGRect oRect = CGRectMake(0, 0, circleImage.size.width, circleImage.size.height);
    UIImageView* circleImageView = [[UIImageView alloc]initWithImage:[UIImage circularScaleNCrop:circleImage scaledToRect:oRect]];
    circleImageView.center = center;
    return circleImageView;
}

@end
