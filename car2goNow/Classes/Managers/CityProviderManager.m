//
//  CityProviderManager.m
//  RideScout
//
//  Created by Brady Miller on 3/2/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "CityProviderManager.h"
#import "constantsAndMacros.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "Provider.h"
#import "RideIconsManager.h"

@implementation CityProviderManager

+ (CityProviderManager *)sharedProvidersForCity {
    static CityProviderManager *_sharedProvidersForCity = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedProvidersForCity = [[self alloc] init];
    });
    return _sharedProvidersForCity;
}

#pragma mark - API Calls

- (void)getProvidersInCityAtLocation:(CLLocation*)location WithSuccess:(void (^)(void))success WithFailure:(void (^)(void))failure {
    NSString *requestString = [NSString stringWithFormat:@"%@api/rides/providers/?api_key=%@&format=json&lat=%f&lng=%f", API_URL, API_KEY, location.coordinate.latitude, location.coordinate.longitude];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:escapedString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak __typeof__(self) weakSelf = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSArray *resultDict = [JSON arrayForKey:@"result"];
        
        NSMutableArray *tmpProviders = [[NSMutableArray alloc] init];
        for (NSDictionary *providerDict in resultDict) {
            Provider *newProvider = [[Provider alloc] init];
            newProvider.name = [providerDict stringForKey:@"name"];
            newProvider.providerId = [providerDict stringForKey:@"id"];
            
            NSString *iconUrl = [providerDict stringForKey:@"icon"];
            newProvider.iconUrl = iconUrl;
            
            CGFloat imageDiam = SCREEN_WIDTH - 40 * 2;
            [[RideIconsManager sharedCache] addImageForUrl:iconUrl withName:newProvider.name withWidth:imageDiam andHeight:imageDiam];
            
            [tmpProviders addObject:newProvider];
        }
        weakSelf.providers = [NSMutableArray arrayWithArray:tmpProviders];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CITYPROVIDERSLOADED object:nil];
        if (success) success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( error.code == -1009 ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:AFNETWORKUNREACHABLE object:nil];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:CITYPROVIDERSTIMEDOUT object:nil];
        }
        if (failure) failure();
        RSLog(@"%@: %@", error, error.userInfo);
    }];
    [operation start];
}

@end
