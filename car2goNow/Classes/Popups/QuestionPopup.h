//
//  QuesitonPopup.h
//  RideScout
//
//  Created by Charlie Cliff on 7/8/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <RideKit/RKPinPopup.h>
#import "RSLabel.h"

@interface QuestionPopup : RKPopup

//@property (copy) void (^acceptedEntryBlock)();

@property (nonatomic, strong) RSLabel *cancelLabel;
@property (nonatomic, strong) RSLabel *acceptLabel;

@property (nonatomic, strong) UIImageView *buttonSeparatorImageView;

- (void)setQuestionText:(NSString *)questiontext;
- (void)setCancelLabelText:(NSString *)text;
- (void)setAcceptLabelText:(NSString *)text;

- (void)setAcceptanceButtonHidden:(BOOL)isHidden;

@end
