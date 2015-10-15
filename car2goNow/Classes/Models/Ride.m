//
//  Ride.m
//  RideScout
//
//  Created by Brady Miller on 2/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Ride.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "AFNetworking.h"
#import "Direction.h"
#import "constantsAndMacros.h"
#import "LocationManager.h"
#import "RidesNearbyManager.h"

@interface Ride ()

@property (nonatomic, readwrite) BOOL directionsNeedUpdate;

@end

@implementation Ride

- (instancetype)initWithDictionary:(NSDictionary *)rideDictionary {
    self = [super init];
    if (self) {
        [self parseDictionary:rideDictionary];
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)rideDictionary {
    self.lat = [[rideDictionary numberForKey:@"lat"] doubleValue];
    self.lng = [[rideDictionary numberForKey:@"lng"] doubleValue];
    self.location = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lng];
    self.distance = [[rideDictionary numberForKey:@"distance"] doubleValue]*3.28084;
    self.providerId = [rideDictionary stringForKey:@"provider_id"];
    self.providerSlug = [rideDictionary stringForKey:@"provider_slug"];
    self.positionId = [rideDictionary stringForKey:@"position_id"];
    self.rideId = [rideDictionary stringForKey:@"id"];
    self.queryType = [rideDictionary stringForKey:@"query_type"];
    self.annotation = [[rideDictionary arrayForKey:@"annotation"] mutableCopy];
    self.detailsDictionary = [rideDictionary dictionaryForKey:@"details"];
    
    NSDictionary *bikeshareDict = [self.detailsDictionary dictionaryForKey:@"bikeshare"];
    self.bikes = [bikeshareDict numberForKey:@"bikes"];
    self.docks = [bikeshareDict numberForKey:@"docks"];

}

#pragma mark - Annotation Builders
#pragma Warning Methods are never called

- (NSDictionary *)getIconDictionaryForAnnotation:(NSString *)annotation {
    NSMutableDictionary *icons = [[NSMutableDictionary alloc] init];
    NSArray *iconParams = [self getParameterStringForAnnotation:annotation];
    for (NSString *param in iconParams) {
        UIImage *icon;
        if ([param isEqualToString:@"icon=thumbsup"]) {
            icon = [UIImage imageNamed:@"thumbs_up.png"];
        }
        else if ([param isEqualToString:@"icon=thumbsdown"]) {
            icon = [UIImage imageNamed:@"thumbs_down.png"];
        }
        [icons setValue:icon forKey:[NSString stringWithFormat:@"{{ %@ }}", param]];
    }
    
    return icons;
}

- (NSArray *)getParameterStringForAnnotation:(NSString *)annotation {
    NSMutableArray *parameterArray = [[NSMutableArray alloc] init];
    
    NSArray *parsedOutOpenersArray = [annotation componentsSeparatedByString:@"{{ "];
    for (int i = 1; i < parsedOutOpenersArray.count; i++) {
        NSString *parameterStringWithCloser = [parsedOutOpenersArray objectAtIndex:i];
        NSArray *parsedOutArray = [parameterStringWithCloser componentsSeparatedByString:@" }}"];
        NSString *parameterString = [parsedOutArray objectAtIndex:0];
        [parameterArray addObject:parameterString];
    }
    
    return parameterArray;
}

#pragma mark - Setters for KVO

- (void)setDirections:(NSArray *)directions {
    _directions = directions;
    [self setValue:@YES forKey:@"directionsNeedUpdate"];
}

#pragma mark - Getters

- (NSArray *)annotation {
    CLLocationDistance metersAway = [self.location distanceFromLocation:[[LocationManager sharedLocationManager] currentLocation]];
    double feetAway = metersAway*3.28084;
    NSString *unitAway;
    NSString *unitName;
    if (feetAway > 1500) {
        unitAway = [NSString stringWithFormat:@"%.1f",feetAway*0.000189394];
        unitName = @"MILES";
    }
    else {
        unitAway = [NSString stringWithFormat:@"%i",(int)feetAway];
        unitName = @"FT";
    }
    
    NSDictionary *bikeshareDict = [self.detailsDictionary dictionaryForKey:@"bikeshare"];
    self.name = [bikeshareDict stringForKey:@"name"];
    NSNumber *bikes = [bikeshareDict numberForKey:@"bikes"];
    NSNumber *docks = [bikeshareDict numberForKey:@"docks"];
    return @[@[unitAway,unitName],@[[NSString stringWithFormat:@"%@",bikes],@"BIKES"],@[[NSString stringWithFormat:@"%@",docks],@"DOCKS"]];
}

- (NSString *)distanceString {
    CLLocationDistance metersAway = [self.location distanceFromLocation:[[LocationManager sharedLocationManager] currentLocation]];
    double feetAway = metersAway*3.28084;
    return (feetAway > 1500) ? [NSString stringWithFormat:@"%.1f",feetAway*0.000189394] : [NSString stringWithFormat:@"%i",(int)feetAway];
}

- (NSString *)distanceNameString {
    CLLocationDistance metersAway = [self.location distanceFromLocation:[[LocationManager sharedLocationManager] currentLocation]];
    double feetAway = metersAway*3.28084;
    return (feetAway > 1500) ? @"MI" : @"FT";
}

@end
