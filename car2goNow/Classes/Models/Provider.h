//
//  Provider.h
//  RideScout
//
//  Created by Brady Miller on 2/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "RideIconsManager.h"
#import "Ride.h"

#define CARSHARE @"driving"
#define TRANSIT @"transit"
#define TAXI @"taxi"
#define BIKESHARE @"biking"
#define RIDESHARE @"rideshare"
#define PARKING @"parking"

typedef enum {
    eProviderTypeBikeshare,
} enumProviderType;

typedef NS_ENUM(NSInteger, ProviderState){
    NoRides = 0,
    UpdatingRides,
    RidesNearbyWithSelectedRide,
    LoadingDirectionsToRide
};

@interface Provider : NSObject

@property (nonatomic, strong) NSArray *ridesNearby;
@property (nonatomic, readonly) BOOL ridesNearbyNeedUpdate;
@property (nonatomic, strong) Ride *selectedRide;
@property (nonatomic, readonly) BOOL selectedRideNeedUpdate;
@property (nonatomic) BOOL updatingRides;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) UIColor *providerColor;
@property (nonatomic, strong) NSString *providerDescription;
@property (nonatomic, strong) NSString *providerId;
@property (nonatomic, strong) NSString *type;
@property (atomic, assign) int providerType;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSArray *features;
@property (nonatomic, strong) NSString *iosNamespace;
@property (nonatomic, strong) NSString *iosDownload;

@property (nonatomic, strong) RideIconsManager *localRideIconCache;  // Dependancy Injection

- (instancetype)initWithDictionary:(NSDictionary *)providerDictionary;

- (BOOL)isEqualToProvider:(Provider *)provider;

@end
