//
//  Weather.h
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, strong) NSNumber *temperatureKelvin;
@property (nonatomic, strong) NSString *weatherDescription;

- (instancetype)initWithDictionary:(NSDictionary *)weatherDict;

@end
