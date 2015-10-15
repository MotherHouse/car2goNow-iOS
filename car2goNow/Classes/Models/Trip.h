//
//  Trip.h
//  RideScout
//
//  Created by Charlie Cliff on 7/20/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocationManager.h"

@interface Trip : NSObject

// Trip Identification Data
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *tripID;

// When (and IF) the Trip Was Cancelled
@property (nonatomic, strong) NSDate *cancelled;

// Trip Start Data
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) NSDate *startTime;

// Trip End Data
@property (nonatomic, strong) CLLocation *endLocation;
@property (nonatomic, strong) NSDate *endTime;

// Trip Geo-Location Data
@property (nonatomic, strong) NSNumber *totalDistance;
@property (nonatomic, strong) NSArray *tripPoints;


// Payment Data
@property (nonatomic, strong) NSNumber *baseFare;
@property (nonatomic, strong) NSNumber *finalFare;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) BOOL paid;
@property (nonatomic, strong) NSDictionary *paymentBreakdown;
@property (nonatomic, strong) NSString *paymentCreditCard;
@property (nonatomic, assign) NSInteger paymentType;
@property (nonatomic, strong) NSDate *paymentCreated;

// Provider Data
@property (nonatomic, strong) NSDictionary *providerData;

- (instancetype)initWithDictionary:(NSDictionary *)tripDictionary;
@end
