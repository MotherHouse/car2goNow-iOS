//
//  Ride.h
//  RideScout
//
//  Created by Brady Miller on 2/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface Ride : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) double distance;  //feet
@property (nonatomic, strong) NSString *distanceString; //dynamic based on location
@property (nonatomic, strong) NSString *distanceNameString; //dynamic based on location
@property (nonatomic, strong) NSString *providerId;
@property (nonatomic, strong) NSString *providerSlug;
@property (nonatomic, strong) NSString *positionId;
@property (nonatomic, strong) NSString *rideId;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *annotation;
@property (nonatomic, strong) NSString *queryType;
@property (nonatomic, strong) NSNumber *docks;
@property (nonatomic, strong) NSNumber *bikes;

@property (nonatomic, strong) NSDictionary *detailsDictionary;
@property (nonatomic, assign) int totalTravelTime;

@property (nonatomic, strong) NSArray *directions;
@property (nonatomic, strong) NSArray *walkingDirections;
@property (nonatomic, strong) NSDate *arrivalTime;
@property (nonatomic, strong) NSString *address;

- (instancetype)initWithDictionary:(NSDictionary *)rideDictionary;

@end
