//
//  Traffic.m
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Traffic.h"
#import <RideKit/NSDictionary+RKParser.h>

@implementation Traffic

- (instancetype)initWithDescription:(NSString *)trafficDescription {
    self = [super init];
    if (self) {
        self.trafficDescription = trafficDescription;
    }
    return self;
}

@end
