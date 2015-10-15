//
//  RideOptionCell.h
//  RideScout
//
//  Created by Jason Dimitriou on 6/5/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provider.h"

#define RIDE_OPTION_CELL_HEIGHT 44

@interface RideOptionCell : UITableViewCell

@property (nonatomic, strong) Provider *provider;

@end
