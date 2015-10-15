//
//  Direction.m
//  RideScout
//
//  Created by Brady Miller on 2/26/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Direction.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "RidesNearbyManager.h"
#import "RideIconsManager.h"
#import <RideKit/UIImage+RKExtras.h>
#import "UIColor+Hex.h"
#import "constantsAndMacros.h"

@implementation Direction

- (instancetype)initWithDictionary:(NSDictionary *)directionDict {
    self = [super init];
    if (self) {
        [self parseDictionary:directionDict];
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)directionDictionary {
    NSString *locationString = [directionDictionary stringForKey:@"start"];
    NSArray *locationLatLng = [locationString componentsSeparatedByString:@","];
    double lat = [[locationLatLng firstObject] doubleValue];
    double lng = [[locationLatLng lastObject] doubleValue];
    self.startLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    locationString = [directionDictionary stringForKey:@"end"];
    locationLatLng = [locationString componentsSeparatedByString:@","];
    lat = [[locationLatLng firstObject] doubleValue];
    lng = [[locationLatLng lastObject] doubleValue];
    self.endLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    self.wayName = [directionDictionary stringForKey:@"way_name"];
    self.duration = [directionDictionary numberForKey:@"duration"];
    self.distance = [[directionDictionary numberForKey:@"distance"] doubleValue]/3.28084;
    
    if (self.distance > 999) {
        self.distance *= 0.000189394;
        self.distanceString = [NSString stringWithFormat:@"%.1f mi",self.distance];
    }
    else {
        self.distanceString = [NSString stringWithFormat:@"%i ft", (int)self.distance];
    }
    
    self.polyline = [directionDictionary stringForKey:@"polyline"];
    self.polylineColor = BCYCLE_LIGHT_GREY;
    
    NSDictionary *manueverDictionary = [directionDictionary dictionaryForKey:@"maneuver"];
    self.instruction = [manueverDictionary stringForKey:@"instruction"];
    self.type = [manueverDictionary stringForKey:@"type"];
    
    [self parseTypeForIconImage];
}

#pragma mark - Setters

- (void)setIconUrl:(NSString *)iconUrl {
    _iconUrl = iconUrl;
    UIImage *providerIcon = [[RideIconsManager sharedCache] imageIconForURL:iconUrl];
    providerIcon = [UIImage imageWithImage:providerIcon scaledToSize:CGSizeMake(DIRECTION_ICON_SIZE, DIRECTION_ICON_SIZE)];
    self.image = providerIcon;
}

#pragma mark - Helpers

- (void)parseTypeForIconImage {
    BOOL bgImage = YES;
    if ([self.type isEqualToString:@"depart"]) {
        self.image = [UIImage imageNamed:@"current_user_map.png"];
        bgImage = NO;
    }
    self.imageNeedsBackground = bgImage;
}

- (BOOL)isEqualToDirection:(Direction *)direction {
    if (!direction) {
        return NO;
    }
    BOOL haveEqaulStartLocations = (!self.startLocation && !direction.startLocation) || ( (self.startLocation.coordinate.latitude == direction.startLocation.coordinate.latitude) && (self.startLocation.coordinate.longitude == direction.startLocation.coordinate.longitude) ) ;
    BOOL haveEqaulEndLocations = (!self.endLocation && !direction.endLocation) || ( (self.endLocation.coordinate.longitude == direction.endLocation.coordinate.longitude) && (self.endLocation.coordinate.latitude == direction.endLocation.coordinate.latitude) );
    BOOL haveEqualDistances = (!self.distance && !direction.distance) || (self.distance==direction.distance);
    BOOL haveEqualDurations = (!self.duration && !direction.direction) || [self.duration isEqual:direction.duration];
    BOOL haveEqualTypes = (!self.type && !direction.type) || [self.type isEqualToString:direction.type];
    BOOL haveEqualDirections = (!self.direction && !direction.direction) || [self.direction isEqualToString:direction.direction];
    BOOL haveEqualTitleInstructions = (!self.titleInstruction && !direction.titleInstruction) || [self.titleInstruction isEqualToString:direction.titleInstruction];
    BOOL haveEqualInstructions = (!self.instruction && !direction.instruction) || [self.instruction isEqualToString:direction.instruction];
    BOOL haveEqualIconURLs = (!self.iconUrl && !direction.iconUrl) || [self.iconUrl isEqualToString:direction.iconUrl];
    BOOL haveEqualWayNames = (!self.wayName && !direction.wayName) || [self.wayName isEqualToString:direction.wayName];
    BOOL haveEqualPolyLines = (!self.polyline && !direction.polyline) || [self.polyline isEqualToString:direction.polyline];
    
    return haveEqaulStartLocations && haveEqaulEndLocations && haveEqualDistances && haveEqualDurations && haveEqualTypes && haveEqualDirections && haveEqualTitleInstructions && haveEqualInstructions && haveEqualIconURLs && haveEqualWayNames && haveEqualPolyLines;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Direction class]]) {
        return NO;
    }
    
    return [self isEqualToDirection:object];
}

@end
