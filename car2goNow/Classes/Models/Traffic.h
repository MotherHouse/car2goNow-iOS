//
//  Traffic.h
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Traffic : NSObject

@property (nonatomic, strong) NSString *trafficDescription;

- (instancetype)initWithDescription:(NSString *)trafficDescription;

@end
