//
//  DirectionsView.h
//  RideScout
//
//  Created by Jason Dimitriou on 5/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"
#import "Direction.h"
#import "Provider.h"

@protocol DirectionsViewDelegate <NSObject>

- (void)directionTapped:(Direction *)direction;

@end

@interface DirectionsView : UIView

@property (nonatomic, strong) Provider *provider;
@property (nonatomic, strong) Ride *ride;
@property (nonatomic, weak) id<DirectionsViewDelegate> delegate;
@property (nonatomic, strong) UITableView *directionsTableView;

@end
