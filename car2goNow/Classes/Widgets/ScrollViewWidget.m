//
//  ScrollViewWidget.m
//  RideScout
//
//  Created by Charlie Cliff on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ScrollViewWidget.h"

@implementation ScrollViewWidget

- (id)initWithWidth:(CGFloat)width RowHeight:(CGFloat)rowHeight HedaerHeight:(CGFloat)headerHeight {
    self = [super init];
    if (self != nil) {
        
        self.data = [[NSArray alloc] init];
        
        self.headerTitle = @"This is a Widget";
        
        self.headerTint = [UIColor whiteColor];
        self.seperatorColor = [UIColor whiteColor];
        self.activeColor = [UIColor redColor];
        self.inactiveColor = [UIColor whiteColor];
        
        self.width = width;
        self.rowHeight = rowHeight;
        self.headerHeight = headerHeight;

        [self layout];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        
        self.width = 200;
        self.rowHeight = 64;
        self.headerHeight = 64;
        
        self.headerTitle = @"This is a Widget";
        
        self.headerTint = [UIColor whiteColor];
        self.seperatorColor = [UIColor whiteColor];
        self.activeColor = [UIColor redColor];
        self.inactiveColor = [UIColor whiteColor];
        
        [self layout];
    }
    return self;
}

#pragma mark - Layout

- (void)layout {
    
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.headerHeight)];
    [headerLabel setText:self.headerTitle];
    [headerLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:30]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:headerLabel];

    headerSeparatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerHeight - 1, self.width, 1)];
    [headerSeparatorView setBackgroundColor:self.seperatorColor];
    [self addSubview:headerSeparatorView];

    tableview = [[UITableView alloc] init];
    tableview.dataSource = self;
    tableview.delegate = self;
    
    [self refresh];
}

- (void) refresh {
    [tableview removeFromSuperview];
    if (self.data.count > 0) {
        [tableview setFrame:CGRectMake(0, self.headerHeight - 3, self.width, self.data.count*self.rowHeight)];
        tableview.backgroundColor = [UIColor redColor];
        tableview.rowHeight = self.rowHeight;
        [self addSubview:tableview];
    }
}

#pragma mark - Setters

- (void)setCellItems:(NSArray *)cellItems {
    _data = cellItems;
    [self refresh];
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

@end
