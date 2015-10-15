//
//  RMMapView+Extras.m
//  RideScout
//
//  Created by Brady Miller on 3/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RMMapView+Extras.h"
#import "constantsAndMacros.h"
#import <Mapbox-iOS-SDK/Mapbox.h>

#define BOUNDINGBOXPADDING 200

@implementation RMMapView (Extras)

// Takes the encoded polyline and turns it into an array of coordinates.
// It then takes that array of coordinates and splits it into smaller arrays of coordinates
// to allow for a smoother animation.
- (NSArray *)getLocationsForEncodedPolyline:(NSString *)encodedString forCords:(NSMutableArray *)cords {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSMutableArray *allCoordsForPolyline = [[NSMutableArray alloc] init];
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        if (cords) [cords addObject:loc];
        [allCoordsForPolyline addObject:loc];
    }
    
    // Splice the polyline coordinates into chunks of cordinates
    // Aka split the polyline into smaller polylines
    // Return the array of arrays of coordinates
    // Aka return the array of arrays of chunks
    NSMutableArray *coordChunk = [[NSMutableArray alloc] init];
    NSMutableArray *coordChunksForPolyline = [[NSMutableArray alloc] init];
    for (int i = 0; i < allCoordsForPolyline.count; i++) {
        [coordChunk addObject:[allCoordsForPolyline objectAtIndex:i]];
        
        if (i % 3 == 0) {
            [coordChunksForPolyline addObject:coordChunk];
            coordChunk = [[NSMutableArray alloc] init];
            [coordChunk addObject:[allCoordsForPolyline objectAtIndex:i]];
        }
    }
    if (coordChunk.count > 0) {
        [coordChunksForPolyline addObject:coordChunk];
    }
    
    return coordChunksForPolyline;
}

+ (NSArray *)getLocationsForEncodedPolyline:(NSString *)encodedString forCords:(NSMutableArray *)cords {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSMutableArray *allCoordsForPolyline = [[NSMutableArray alloc] init];
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        if (cords) [cords addObject:loc];
        [allCoordsForPolyline addObject:loc];
    }
    
    // Splice the polyline coordinates into chunks of cordinates
    // Aka split the polyline into smaller polylines
    // Return the array of arrays of coordinates
    // Aka return the array of arrays of chunks
    NSMutableArray *coordChunk = [[NSMutableArray alloc] init];
    NSMutableArray *coordChunksForPolyline = [[NSMutableArray alloc] init];
    for (int i = 0; i < allCoordsForPolyline.count; i++) {
        [coordChunk addObject:[allCoordsForPolyline objectAtIndex:i]];
        
        if (i % 3 == 0) {
            [coordChunksForPolyline addObject:coordChunk];
            coordChunk = [[NSMutableArray alloc] init];
            [coordChunk addObject:[allCoordsForPolyline objectAtIndex:i]];
        }
    }
    if (coordChunk.count > 0) {
        [coordChunksForPolyline addObject:coordChunk];
    }
    
    return coordChunksForPolyline;
}

- (void)zoomIntoMapWithCoords:(NSArray *)coords {
    RMAnnotation *ann = [[RMAnnotation alloc] initWithMapView:self coordinate:self.centerCoordinate andTitle:@"polyline"];
    [ann setBoundingBoxFromLocations:coords];
    RMProjectedRect rect = ann.projectedBoundingBox;
    
    RMProjectedPoint newSWPoint = RMProjectedPointMake(rect.origin.x - BOUNDINGBOXPADDING, rect.origin.y - BOUNDINGBOXPADDING);
    CLLocationCoordinate2D sw = [[self projection] projectedPointToCoordinate:newSWPoint];
    RMProjectedPoint newNEPoint = RMProjectedPointMake(newSWPoint.x + rect.size.width + BOUNDINGBOXPADDING * 2, newSWPoint.y + rect.size.height + BOUNDINGBOXPADDING * 2);
    CLLocationCoordinate2D ne = [[self projection] projectedPointToCoordinate:newNEPoint];
    
    // Resetting the Center Coordinate is necessary after using the *zoomWithLatitudeLongitudeBoundsSouthWest* method due to a bug in the MapBox code
//    CLLocationCoordinate2D currentCenter = self.centerCoordinate;
    [self zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
//    [self setCenterCoordinate:currentCenter];
    
}

@end
