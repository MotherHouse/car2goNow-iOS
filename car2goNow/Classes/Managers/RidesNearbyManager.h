//
//  RidesNearbyManager.h
//  RideScout
//
//  Created by Jason Dimitriou on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RideOptions.h"

@interface RidesNearbyManager : NSObject

@property (nonatomic, strong) RideOptions *rideOptions;
@property (nonatomic, strong) NSDictionary *resultsDictionary;
@property (nonatomic, assign) BOOL updating;
@property (nonatomic, strong) NSDate *lastUpdateTime;

+ (RidesNearbyManager *)sharedRidesByLocation;

- (void)updateRidesNearbyWithCompletion:(void (^)(void))completion;

@end
