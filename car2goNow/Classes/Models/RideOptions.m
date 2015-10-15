//
//  RideOptions.m
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RideOptions.h"
#import <RideKit/NSDictionary+RKParser.h>

@implementation RideOptions

- (instancetype)initWithDictionary:(NSDictionary *)resultDict {
    self = [self init];
    if (self) {
        [self parseDictionary:resultDict];
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)resultDict {
    
    NSArray *providerOrderArray = [resultDict arrayForKey:@"provider_order"];
    NSDictionary *providersDict = [resultDict dictionaryForKey:@"providers"];
    NSMutableDictionary *providerSlugToProviderDict = [NSMutableDictionary dictionary];
    for (NSString *key in providersDict.allKeys) {
        NSArray *providersArray = [providersDict objectForKey:key];
        for (NSDictionary *providerDictionary in providersArray) {
            Provider *newProvider = [[Provider alloc] initWithDictionary:providerDictionary];
            
            NSArray *ridesArray = [providerDictionary arrayForKey:@"rides"];
            NSMutableArray *ridesNearby = [[NSMutableArray alloc] init];
            for (NSDictionary *rideDictionary in ridesArray) {
                Ride *newRide = [[Ride alloc] initWithDictionary:rideDictionary];
                if (newRide.annotation.count > 0) [ridesNearby addObject:newRide];
            }
            newProvider.ridesNearby = [NSArray arrayWithArray:ridesNearby];
                        
            BOOL providerUsed = YES;
            if (providerUsed) {
                [providerSlugToProviderDict setObject:newProvider forKey:newProvider.slug];
            }
        }
    }
    
    NSMutableArray *providers = [[NSMutableArray alloc] init];
    for (NSString *providerSlug in providerOrderArray) {
        Provider *provider = [providerSlugToProviderDict objectForKey:providerSlug];
        if (provider) {
            [providers addObject:provider];
        }
    }
    
    self.providers = [providers copy];
    
    NSDictionary *weatherDict = [resultDict dictionaryForKey:@"weather"];
    self.weather = [[Weather alloc] initWithDictionary:weatherDict];
    
    self.traffic = [[Traffic alloc] initWithDescription:[resultDict stringForKey:@"traffic"]];
}

- (Provider *)providerForRide:(Ride *)ride {
    for (Provider *prov in self.providers) {
        if ([prov.providerId isEqualToString:ride.providerId]) return prov;
        if ([prov.ridesNearby containsObject:ride]) return prov;
    }
    
    for (Provider *prov in self.providers) {
        if ([prov.ridesNearby containsObject:ride]) return prov;
    }
    
    return nil;
}

@end
