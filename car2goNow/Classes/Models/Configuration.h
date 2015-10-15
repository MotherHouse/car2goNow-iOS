//
//  Configuration.h
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKProfile;

@interface Configuration : NSObject

@property (nonatomic, strong) RKProfile *profile;
@property (nonatomic, strong) NSDictionary *screenAds;
@property (nonatomic, strong) NSDictionary *rideTypes;

- (instancetype)initWithDictionary:(NSDictionary *)configDict;

@end
