//
//  RideOptions.h
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"
#import "Traffic.h"
#import "Ride.h"
#import "Provider.h"

@interface RideOptions : NSObject

@property (nonatomic, strong) NSArray *providers;
@property (nonatomic, strong) Weather *weather;
@property (nonatomic, strong) Traffic *traffic;

- (instancetype)initWithDictionary:(NSDictionary *)resultDict;
- (void)parseDictionary:(NSDictionary *)resultDict;

- (Provider *)providerForRide:(Ride *)ride;

@end
