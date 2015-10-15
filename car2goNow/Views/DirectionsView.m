//
//  DirectionsView.m
//  RideScout
//
//  Created by Jason Dimitriou on 5/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "DirectionsView.h"
#import "DirectionCell.h"
#import "constantsAndMacros.h"
#import "UIImage+Circles.h"
#import <RideKit/UIImage+RKExtras.h>
#import "RideIconsManager.h"

@interface DirectionsView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *directions;

@end

@implementation DirectionsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    [self setBackgroundColor:[UIColor whiteColor]];
    self.userInteractionEnabled = YES;
    
    self.directionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.directionsTableView.scrollEnabled = YES;
    [self.directionsTableView setDelegate:self];
    [self.directionsTableView setDataSource:self];
    [self.directionsTableView setBackgroundColor:[UIColor clearColor]];
    [self.directionsTableView setSeparatorColor:[UIColor colorWithWhite:1.0 alpha:0.20]];
    [self.directionsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.directionsTableView registerClass:[DirectionCell class] forCellReuseIdentifier:@"DirectionCell"];
    [self addSubview:self.directionsTableView];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.directions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    Direction *direction = self.directions[indexPath.row];
    return [self cellHeightForDirection:direction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DirectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectionCell"];
//    if (!cell) {
        DirectionCell *cell = [[DirectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DirectionCell"];
//    }
    Direction *direction = self.directions[indexPath.row];
    
    if (indexPath.row != 0) {
        Direction *prevDirection = self.directions[indexPath.row - 1];
        cell.prevCellLineColor = prevDirection.polylineColor;
    }
    
    cell.firstStep = (indexPath.row == 0);
    cell.finalStep = (indexPath.row + 1 == self.directions.count);
    
    cell.direction = direction;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Direction *direction = self.directions[indexPath.row];
    if (self.delegate) [self.delegate directionTapped:direction];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Setters

- (void)setRide:(Ride *)ride {
    _ride = ride;
    NSMutableArray *directions = [[NSMutableArray alloc] init];
    for (Direction *direct in ride.directions) {
        [directions addObject:direct];
    }
    
    Direction *arriveAtDirection = [[Direction alloc] init];
    arriveAtDirection.titleInstruction = @"You have arrived";
    arriveAtDirection.startLocation = ride.location;
    
    UIImage *rideImage = self.ride.image;
    rideImage = [UIImage imageWithImage:rideImage scaledToSize:CGSizeMake(DIRECTION_ICON_SIZE, DIRECTION_ICON_SIZE)];
    arriveAtDirection.image = rideImage;
    [directions addObject:arriveAtDirection];
    
    self.directions = [NSArray arrayWithArray:directions];
    [self.directionsTableView reloadData];
    CGRect frame = self.directionsTableView.frame;
    [self.directionsTableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.bounds.size.height)];
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.directionsTableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

#pragma mark - Helpers

// Row height is called before the acutal cell is created and drawn, therefore
// we predict the row height by creating a temporary cell to measure
- (CGFloat)cellHeightForDirection:(Direction *)direction {
    DirectionCell *tempCell;
    if (!tempCell) {
        tempCell = [[DirectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tempCell"];
    }
    tempCell.direction = direction;
    return [tempCell cellHeight];
}

@end
