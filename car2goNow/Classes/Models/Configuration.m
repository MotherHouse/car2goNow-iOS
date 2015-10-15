//
//  Configuration.m
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Configuration.h"
#import <RideKit/RKProfile.h>
#import <RideKit/NSDictionary+RKParser.h>

@implementation Configuration

- (instancetype)initWithDictionary:(NSDictionary *)configDict {
    self = [super init];
    if (self) {
        [self parseDictionary:configDict];
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)configDict {
    self.screenAds = [configDict dictionaryForKey:@"screen_ads"];
    self.rideTypes = [configDict dictionaryForKey:@"ride_types"];
}

- (BOOL)isEqualToConfiguration:(Configuration *)configuration {
    if (!configuration) {
        return NO;
    }
    BOOL haveEqualProfiles = (!self.profile && !configuration.profile) || ( [self.profile isEqual:configuration.profile]) ;
    BOOL haveEqualScreenAds = (!self.screenAds && !configuration.screenAds) || ( [self.screenAds isEqualToDictionary:configuration.screenAds]) ;
    BOOL haveEqualRideTypes = (!self.rideTypes && !configuration.rideTypes) || ( [self.rideTypes isEqualToDictionary:configuration.rideTypes]) ;
    
    return haveEqualProfiles && haveEqualScreenAds && haveEqualRideTypes;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Configuration class]]) {
        return NO;
    }
    
    return [self isEqualToConfiguration:object];
}

@end
