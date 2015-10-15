//
//  ProfileWidgetCell.h
//  RideScout
//
//  Created by Jason Dimitriou on 6/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileCellData.h"
#import "SWTableViewCell.h"

#define PROFILE_WIDGET_CELL_HEIGHT 44

#define DEFAULT_TITLE_FONT @"OpenSans-Semibold"
#define DEFAULT_TITLE_FONT_SIZE 11

@interface ProfileWidgetCell : SWTableViewCell

@property (nonatomic, strong) ProfileCellData *cellData;
@property (nonatomic) BOOL showSeparator;
@property (nonatomic) CGRect iconFrame;

@end
