//
//  DirectionsManager.h
//  RideScout
//
//  Created by Charlie Cliff on 6/1/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Ride.h"

@interface DirectionsManager : NSObject

+ (void)getAddressForCoordinate:(CLLocation*)inputLocation withSuccess:(void (^)(NSString*))success withFailure:(void (^)(void))failure;

+ (void)getDirectionsForRide:(Ride *)ride withCompletion:(void (^)(void))completion andFailure:(void (^)(void))failure;

@end
