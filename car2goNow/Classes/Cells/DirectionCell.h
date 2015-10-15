//
//  DirectionCell.h
//  RideScout
//
//  Created by Jason Dimitriou on 3/5/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Direction.h"

#define DIRECTION_CELL_HEIGHT 80

@interface DirectionCell : UITableViewCell

@property (nonatomic, strong) Direction *direction;
@property (nonatomic, strong) UIColor *prevCellLineColor;

@property (nonatomic) BOOL firstStep;
@property (nonatomic) BOOL finalStep;

- (CGFloat)cellHeight;

@end
