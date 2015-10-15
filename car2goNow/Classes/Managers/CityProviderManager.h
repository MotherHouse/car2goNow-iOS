//
//  CityProviderManager.h
//  RideScout
//
//  Created by Brady Miller on 3/2/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "AFNetworking.h"

@interface CityProviderManager : NSObject

@property (nonatomic, strong) NSMutableArray *providers;

+ (CityProviderManager *)sharedProvidersForCity;
- (void)getProvidersInCityAtLocation:(CLLocation*)locaiton WithSuccess:(void (^)(void))success WithFailure:(void (^)(void))failure;

@end
