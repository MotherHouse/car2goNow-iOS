//
//  DirectionsManager.m
//  RideScout
//
//  Created by Charlie Cliff on 6/1/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "DirectionsManager.h"
#import <AFNetworking/AFNetworking.h>
#import "constantsAndMacros.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "LocationManager.h"
#import "RidesNearbyManager.h"
#import "Direction.h"

@implementation DirectionsManager

#pragma mark - Encoding Addresses

+ (void)getAddressForCoordinate:(CLLocation*)inputLocation withSuccess:(void (^)(NSString*))success withFailure:(void (^)(void))failure{
    float lat = inputLocation.coordinate.latitude;
    float lng = inputLocation.coordinate.longitude;
    NSString *requestString = [NSString stringWithFormat:@"%@api/directions/reverse-geocode/?api_key=%@&lat=%f&lng=%f", API_URL, API_KEY, lat, lng];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:escapedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSONDict = (NSDictionary *)responseObject;
        NSString *address = [JSONDict objectForKey:@"result"];
        if ( success ) success(address);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( failure ) failure();
    }];
}

#pragma mark - Directions for all non-transit rides

+ (void)getDirectionsForRide:(Ride *)ride withCompletion:(void (^)(void))completion andFailure:(void (^)(void))failure {
    CLLocation *currentLocation = [[LocationManager sharedLocationManager] currentLocation];
    NSString *currentLocationString = [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    NSString *providerLocationString = [NSString stringWithFormat:@"%f,%f", ride.location.coordinate.latitude, ride.location.coordinate.longitude];
    
    NSString *modeString = @"walking";
    Provider *provider = [[[RidesNearbyManager sharedRidesByLocation] rideOptions] providerForRide:ride];
    
    NSString *requestString = [NSString stringWithFormat:@"%@directions/get-directions/?api_key=%@&start=%@&end=%@&mode=%@", API_URL, API_KEY, currentLocationString, providerLocationString, modeString];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = responseObject;
        NSArray *directionsArray = [JSON arrayForKey:@"result"];
        
        int totalTravelTime = 0;
        NSMutableArray *directions = [[NSMutableArray alloc] init];
        NSMutableArray *walkingDirectionSteps = [[NSMutableArray alloc] init];
        NSMutableArray *walkingDirectionSubSteps = [[NSMutableArray alloc] init];
        for (NSDictionary *directionsDict in directionsArray) {
            Direction *direction = [[Direction alloc] initWithDictionary:directionsDict];
            if ([direction.type isEqualToString:@"arrive"]) continue;
            
            if ([direction.type isEqualToString:@"provider_switch"]) {
                direction.instruction = [NSString stringWithFormat:@"Take %@", provider.name];
                direction.image = ride.image;
            }
            [walkingDirectionSubSteps addObject:direction];
            [directions addObject:direction];
            totalTravelTime += [direction.duration intValue];
        }
        
        if (walkingDirectionSubSteps.count > 0) {
            [walkingDirectionSteps addObject:[NSArray arrayWithArray:walkingDirectionSubSteps]];
        }
        
        ride.totalTravelTime = totalTravelTime;
        
        //Gets a date object in current time zone
        NSDateFormatter *gmtFormatter = [[NSDateFormatter alloc] init];
        [gmtFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [gmtFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
        [localFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [localFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *curTimeZoneDate = [gmtFormatter dateFromString:[localFormatter stringFromDate:[NSDate date]]];
        
        ride.arrivalTime = [curTimeZoneDate dateByAddingTimeInterval:ride.totalTravelTime];
        ride.walkingDirections = [NSArray arrayWithArray:walkingDirectionSteps];
        ride.directions = [NSArray arrayWithArray:directions];
        
        if (completion) completion();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        RSLog(@"%@: %@", error, error.userInfo);
        if (failure) failure();
        
    }];
    [operation start];
}

#pragma mark - Helpers



@end
