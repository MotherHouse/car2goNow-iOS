//
//  Feature.h
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feature : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSArray *behaviors;
@property (nonatomic, strong) NSNumber *type;

+ (NSArray *)getFeaturesFromArray:(NSArray *)featuresDictArray;

- (BOOL)isEqualToFeature:(Feature *)feature;

@end
