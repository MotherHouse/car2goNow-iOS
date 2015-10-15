//
//  RSDatePicker.h
//  RideScout
//
//  Created by Jason Dimitriou on 5/22/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PICKER_HEIGHT 216

@protocol RSDatePickerDelegate <NSObject>

@optional

-(void)dateChanged:(id)sender;

@end

@interface RSDatePicker : UIControl

@property (nonatomic, strong) id<RSDatePickerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *fontNameExtension;
@property (nonatomic, assign) CGFloat fontSize;

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly;
- (void)showDateOnPicker:(NSDate *)date;
- (void)offsetPicketToCenter:(CGFloat)offset;

@end