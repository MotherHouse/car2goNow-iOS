//
//  Weather.m
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Weather.h"
#import <RideKit/NSDictionary+RKParser.h>

@implementation Weather

- (instancetype)initWithDictionary:(NSDictionary *)weatherDict {
    self = [super init];
    if (self) {
        [self parseDictionary:weatherDict];
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)weatherDict {
    self.temperatureKelvin = [weatherDict numberForKey:@"kelvin"];
    self.weatherDescription = [weatherDict stringForKey:@"summary"];
}

@end
