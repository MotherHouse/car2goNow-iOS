//
//  LocationManager.h
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE @"Location Services Are Not Available"

@class Place;

@interface LocationManager : NSObject <CLLocationManagerDelegate> {
    // Detemring the Most Accurate Location when the Locaiotn Manager starts updating
    NSTimer *gpsAccuracyTimer;
    
    // An Array of Points that are stored for a Trip Model
    NSMutableArray *pointsForTrip;
    BOOL shouldSaveCurrentLocationToTripColleciton;
}
@property (nonatomic, strong) CLLocationManager *locationManager;

// Current location is the location used for directions
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong,readonly) CLLocation *mostAccurateLocation;

+ (LocationManager *)sharedLocationManager;

- (void)startUpdatingLocationNotify:(BOOL)_notify;
- (void)stopUpdatingLocation;
- (void)startMonitoringVisits;
- (void)stopMonitoringVisits;
- (void)getLocation:(void (^)(CLLocation *loc))completion;

// Monitoring Location Services Enabled
- (void)determineLocationServicesAreEnabled;


- (void)updateMostAccurateLocation:(CLLocation*)location;
- (void)postFoundLocationNotification;
    
+ (void)getAddressForLat:(CGFloat)lat andLng:(CGFloat)lng completion:(void (^)(NSString *address))completion;
+ (void)getLatLngForAddress:(NSString *)address completion:(void (^)(CLLocation *loc))completion;
+ (void)checkSupportedCityForLat:(CGFloat)lat andLng:(CGFloat)lng completion:(void(^)(BOOL supported, NSString *cityName))completion;

// Collecting Points for Trip Models
- (void)startCollectingPointsForTrip;
- (NSArray *)stopCollectingPointsForTrip;

@end
