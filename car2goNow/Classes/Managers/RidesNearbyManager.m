//
//  RidesNearbyManager.m
//  RideScout
//
//  Created by Jason Dimitriou on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RidesNearbyManager.h"
#import "AFNetworking.h"
#import "Provider.h"
#import "Ride.h"
#import "RideIconsManager.h"
#import "constantsAndMacros.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "LocationManager.h"
#import "UIColor+Hex.h"
#import <RideKit/RideKit.h>

@interface RidesNearbyManager ()

@end

@implementation RidesNearbyManager

+ (RidesNearbyManager *)sharedRidesByLocation {
    static RidesNearbyManager *_sharedRidesByLocation = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedRidesByLocation = [[self alloc] init];
        _sharedRidesByLocation.updating = NO;
    });
    return _sharedRidesByLocation;
}

#pragma mark - API Calls

- (void)updateRidesNearbyWithCompletion:(void (^)(void))completion {
    self.updating = YES;
    self.lastUpdateTime = [NSDate date];
    
    CLLocation *setLocation = [[LocationManager sharedLocationManager] currentLocation];
    
    CGFloat lat = setLocation.coordinate.latitude;
    CGFloat lng = setLocation.coordinate.longitude;
    
//    NSString *requestString = [NSString stringWithFormat:@"%@api/rides/near/?api_key=%@&radius=%d&format=json&lat=%f&lng=%f&AWS=true", API_URL, API_KEY, RIDES_RADIUS, lat, lng];
    NSString *requestString = [NSString stringWithFormat:@"%@city/rides-near/?api_key=%@&radius=%d&format=json&lat=%f&lng=%f&provider_slug=bcycle&AWS=true&limit=1000", API_URL, API_KEY, RIDES_RADIUS, lat, lng];

    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak __typeof__(self) weakSelf = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSDictionary *resultDict = [JSON dictionaryForKey:@"result"];
        
        weakSelf.resultsDictionary = [resultDict copy];
        weakSelf.rideOptions = [[RideOptions alloc] initWithDictionary:resultDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.updating = NO;
            if (completion) completion();
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        RSLog(@"API ERROR updateRidesNearbyWithCompletion -- %@", operation.responseObject);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf updateRidesNearbyWithCompletion:completion];
        });
        
    }];
    [operation start];
}

@end
