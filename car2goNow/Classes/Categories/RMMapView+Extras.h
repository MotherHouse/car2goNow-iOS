//
//  RMMapView+Extras.h
//  RideScout
//
//  Created by Brady Miller on 3/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RMMapView.h"

@interface RMMapView (Extras)

+ (NSArray *)getLocationsForEncodedPolyline:(NSString *)encodedString forCords:(NSMutableArray *)cords;
- (NSArray *)getLocationsForEncodedPolyline:(NSString *)encodedString forCords:(NSMutableArray *)cords;
- (void)zoomIntoMapWithCoords:(NSArray *)coords;

@end
