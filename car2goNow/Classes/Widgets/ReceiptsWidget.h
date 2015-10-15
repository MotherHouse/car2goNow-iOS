//
//  ReceiptsWidget.h
//  RideScout
//
//  Created by Charlie Cliff on 8/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ProfileWidget.h"

@interface ReceiptsWidget : ProfileWidget

@property (nonatomic) NSInteger numberOfReceiptsShown;
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIButton *moreButton;

@end
