//
//  ScrollViewWidget.m
//  RideScout
//
//  Created by Charlie Cliff on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ProfileWidget.h"
#import "RSLabel.h"
#import "constantsAndMacros.h"
#import "ProfileWidgetCell.h"
#import <RideKit/RKPinPopup.h>

@implementation ProfileWidget 

- (instancetype)initWithWidth:(CGFloat)width {
    self = [self init];
    if (self) {
        self.widgetWidth = width;
        [self buildView];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        _cellItems = [[NSArray alloc] init];
        _headerTitle = @"Profile Widget";
        _profilePopup = nil;
    }
    return self;
}

- (void)buildView {
    // Header
    self.headerLabel = [[RSLabel alloc] initWithFrame:CGRectMake(INDENTATION, 0, self.widgetWidth - INDENTATION, WIDGET_HEADER_HEIGHT)];
    [self.headerLabel setText:self.headerTitle];
    [self.headerLabel setFontName:DEFAULT_HEADER_FONT];
    [self.headerLabel setFontSize:DEFAULT_HEADER_FONT_SIZE];
    [self.headerLabel setTextAlignment:NSTextAlignmentLeft];
    [self.headerLabel setTextColor:[UIColor darkGrayColor]];
    [self.headerLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.headerLabel];
    
    // Separator
    self.separatorLine = [[UIImageView alloc] init];
    CGFloat headerSeparatorLineY = self.headerLabel.frame.size.height - 1;
    [self.separatorLine setFrame:CGRectMake(INDENTATION, headerSeparatorLineY, self.widgetWidth- INDENTATION, STANDARD_LINE_WEIGHT)];
    self.separatorLine.backgroundColor = COOPER_GRAY;
    [self addSubview:self.separatorLine];

    // Table View
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WIDGET_HEADER_HEIGHT, self.widgetWidth, self.cellItems.count*PROFILE_WIDGET_CELL_HEIGHT)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.allowsMultipleSelection = NO;
    [self.tableView registerClass:[ProfileWidgetCell class] forCellReuseIdentifier:@"ProfileWidgetCell"];
    [self addSubview:self.tableView];
    
    // Self View
    [self setFrame:CGRectMake(0, 0, self.widgetWidth, self.tableView.frame.origin.y + self.tableView.frame.size.height)];
    [self setBackgroundColor:[UIColor clearColor]];

}

- (void)updateViewSize {
    CGRect frame = self.tableView.frame;
    [self.tableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.cellItems.count*PROFILE_WIDGET_CELL_HEIGHT)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.tableView.frame.origin.y + self.tableView.frame.size.height)];
}

- (void)reload {
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return self.cellItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PROFILE_WIDGET_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileWidgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileWidgetCell"];
    if (!cell) {
        cell = [[ProfileWidgetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileWidgetCell"];
    }
    cell.showSeparator = YES;
    cell.cellData = [self.cellItems objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.leftUtilityButtons = nil;
    cell.rightUtilityButtons = nil;
    return cell;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:0.0] icon:[UIImage imageNamed:@"hub_delete.png"]];
    return rightUtilityButtons;
}

- (void)presentPopup:(RKPopup *)popup {
    if (animating) return;
    else animating = YES;
    [self.superview bringSubviewToFront:self];
    __weak __typeof(self)weakSelf = self;
    
    [popup presentPopupFromView:self completion:^{
        animating = false;
        //        [weakSelf.containterScrollView setUserInteractionEnabled:NO];
        [weakSelf.containterScrollView setScrollEnabled:NO];
        weakSelf.profilePopup = popup;
    }];
    
}

- (void)closePopup:(RKPopup *)popup {
    __weak __typeof(self)weakSelf = self;
    [popup closePopupCompletion:^{
        //        [weakSelf.containterScrollView setUserInteractionEnabled:YES];
        [weakSelf.containterScrollView setScrollEnabled:YES];
        weakSelf.profilePopup = nil;
    }];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            return NO;
            break;
        case 2:
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


#pragma mark - Setters

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    self.headerLabel.text = headerTitle;
}

@end
