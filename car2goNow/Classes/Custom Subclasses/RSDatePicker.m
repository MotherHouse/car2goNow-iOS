//
//  RSDatePicker.m
//  RideScout
//
//  Created by Jason Dimitriou on 5/22/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//
//  Source code from https://github.com/attias/AADatePicker

#import "RSDatePicker.h"
#import "RSLabel.h"
#import "constantsAndMacros.h"

#define ROW_HEIGHT 35

@interface RSDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger nDays;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIImageView *topSeparator;
@property (nonatomic, strong) UIImageView *bottomSeparator;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (readonly, strong) NSDate *earliestPresentedDate;
@property (nonatomic) BOOL showOnlyValidDates;

@end

@implementation RSDatePicker

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    self.minDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    [self commonInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    assert((((minDate) && (maxDate)) && ([minDate compare:maxDate] != NSOrderedDescending)));
    
    self.minDate = minDate;
    self.maxDate = maxDate;
    self.showOnlyValidDates = showValidDatesOnly;
    
    [self commonInit];
    
    return self;
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

-(NSDate *)earliestPresentedDate {
    return self.showOnlyValidDates ? self.minDate : [NSDate dateWithTimeIntervalSince1970:0];
}

- (void)commonInit {
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    [self initDate];
    
    [self showDateOnPicker:self.date];
    
    [self addSubview:self.picker];
    
    CGFloat y = (PICKER_HEIGHT-ROW_HEIGHT)/2-1;
    self.topSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.picker.frame.size.width, 1)];
    [self.topSeparator setBackgroundColor:RIDESCOUT_LIGHT_GREY_DIVIDER];
    [self addSubview:self.topSeparator];
    
    y += ROW_HEIGHT+2;
    self.bottomSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.picker.frame.size.width, 1)];
    [self.bottomSeparator setBackgroundColor:RIDESCOUT_LIGHT_GREY_DIVIDER];
    [self addSubview:self.bottomSeparator];
}

-(void)showDateOnPicker:(NSDate *)date {
    self.date = date;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    [components setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger amPM = (hour < 12) ? 0 : 1;
    
    [self.picker selectRow:hour-1 inComponent:0 animated:YES];
    [self.picker selectRow:minute inComponent:1 animated:YES];
    [self.picker selectRow:amPM inComponent:2 animated:YES];
}

-(void)initDate {
    NSInteger startDayIndex = 0;
    NSInteger startHourIndex = 0;
    NSInteger startMinuteIndex = 0;
    
    if ((self.minDate) && (self.maxDate) && self.showOnlyValidDates) {
        NSDateComponents *components = [self.calendar components:NSCalendarUnitDay
                                                        fromDate:self.minDate
                                                          toDate:self.maxDate
                                                         options:0];
        
        nDays = components.day + 1;
    } else {
        nDays = INT16_MAX;
    }
    NSDate *dateToPresent;
    
    if ([self.minDate compare:[NSDate date]] == NSOrderedDescending) {
        dateToPresent = self.minDate;
    } else if ([self.maxDate compare:[NSDate date]] == NSOrderedAscending) {
        dateToPresent = self.maxDate;
    } else {
        dateToPresent = [NSDate date];
    }
    
    NSDateComponents *todaysComponents = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                          fromDate:self.earliestPresentedDate
                                                            toDate:dateToPresent
                                                           options:0];
    
    startDayIndex = todaysComponents.day;
    startHourIndex = todaysComponents.hour;
    startMinuteIndex = todaysComponents.minute;
    
    self.date = [NSDate dateWithTimeInterval:startDayIndex*24*60*60+startHourIndex*60*60+startMinuteIndex*60 sinceDate:self.earliestPresentedDate];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return INT16_MAX;
    }
    else if (component == 1) {
        return INT16_MAX;
    }
    else {
        return 2;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 1)
        return 40;
    return 60;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return ROW_HEIGHT;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (!self.textColor) self.textColor = BCYCLE_LIGHT_PURPLE;
    if (!self.fontSize) self.fontSize = 16;
    
    RSLabel *lblDate = [[RSLabel alloc] init];
    [lblDate setTextColor:self.textColor];
    [lblDate setFontSize:self.fontSize];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    if (component == 0) { //Hour
        [lblDate setText:[NSString stringWithFormat:@"%d",(int)(row % 12)+1]];
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 1) { // Minutes
        [lblDate setText:[NSString stringWithFormat:@"%02d",(int)(row % 60)]];
        lblDate.textAlignment = NSTextAlignmentLeft;
    }
    if (component == 2) { // AM/PM
        if (row == 0) [lblDate setText:@"AM"];
        else if (row == 1) [lblDate setText:@"PM"];
        lblDate.textAlignment = NSTextAlignmentLeft;
    }
    
    return lblDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger hour = ([pickerView selectedRowInComponent:0] % 24) + 1;
    NSInteger minute = [pickerView selectedRowInComponent:1] % 60;

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [components setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [components setHour:hour];
    [components setMinute:minute];
    
    self.date = [calendar dateFromComponents:components];
    
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(dateChanged:)])) {
        [self.delegate dateChanged:self];
    }
}

- (void)offsetPicketToCenter:(CGFloat)offset {
    self.picker.frame = CGRectOffset(self.picker.frame, offset, 0);
    self.clipsToBounds = YES;
}

@end
