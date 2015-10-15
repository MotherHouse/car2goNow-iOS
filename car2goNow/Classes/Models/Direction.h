//
//  Direction.h
//  RideScout
//
//  Created by Brady Miller on 2/26/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Ride.h"

#define DIRECTION_ICON_SIZE 36

@interface Direction : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)directionDict;
- (void)parseDictionary:(NSDictionary *)directionDictionary;

@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *endLocation;

@property (nonatomic, assign) double distance;
@property (nonatomic, strong) NSString *distanceString;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, strong) NSString *titleInstruction;
@property (nonatomic, strong) NSString *instruction;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *wayName;

@property (nonatomic, strong) NSString *polyline;
@property (nonatomic, strong) UIColor *polylineColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL imageNeedsBackground;

- (BOOL)isEqualToDirection:(Direction *)direction;

@end
