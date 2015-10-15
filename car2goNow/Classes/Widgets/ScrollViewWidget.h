//
//  ScrollViewWidget.h
//  RideScout
//
//  Created by Charlie Cliff on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewWidget : UIView <UITableViewDataSource, UITableViewDelegate> {
    UILabel *headerLabel;
    UIView *headerSeparatorView;
    UITableView *tableview;
}

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat headerHeight;

@property (nonatomic,strong) NSString *headerTitle;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) UIColor *headerTint;
@property (nonatomic,strong) UIColor *seperatorColor;
@property (nonatomic,strong) UIColor *activeColor;
@property (nonatomic,strong) UIColor *inactiveColor;

- (id)initWithWidth:(CGFloat)width RowHeight:(CGFloat)rowHeight HedaerHeight:(CGFloat)headerHeight;

@end
