//
//  ConfigManager.m
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ConfigManager.h"
#import "AFNetworking.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "constantsAndMacros.h"
#import "LocationManager.h"
#import <AdSupport/AdSupport.h>

@implementation ConfigManager

+ (ConfigManager *)sharedConfiguration {
    static ConfigManager *_sharedConfiguration = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedConfiguration = [[self alloc] init];
        _sharedConfiguration.updating = NO;
    });
    return _sharedConfiguration;
}

#pragma mark - API Calls

- (void)getConfig {
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString].uppercaseString;
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    
    self.updating = YES;
    
    CLLocation *location = [[LocationManager sharedLocationManager] currentLocation];

    NSString *requestString = [NSString stringWithFormat:@"%@api/config/?v=%d&api_key=%@&lat=%f&lng=%f&initial_launch=true&ios_ifa=%@&ios_ifv=%@&push_token=%@", API_URL, API_VERSION, API_KEY, location.coordinate.latitude, location.coordinate.longitude, idfa, idfv, pushToken];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak __typeof__(self) weakSelf = self;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSDictionary *resultDict = [JSON dictionaryForKey:@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Set the uid
            weakSelf.updating = NO;
            weakSelf.configuration = [[Configuration alloc] initWithDictionary:resultDict];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        RSLog(@"%@: %@", error, error.userInfo);
    }];
    [operation start];
}

@end
