//
//  LocationManager.m
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "LocationManager.h"
#import "constantsAndMacros.h"
//#import "RidesNearbyManager.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
//#import "ConfigManager.h"
#import "AFNetworking.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "CityProviderManager.h"
#import <SplunkMint/SplunkMint.h>
#import "TripManager.h"

#define MINIMUM_GPS_HORIZONTAL_ACCURACY 25
#define GPS_ACCURACY_TIMER_TIMEOUT_TIME 10.0

#define TRIP_POINT_COLLECITON_INTERVAL 10.0

#define DISTANCE_FILTER 15.0

#define DEFAULT_LOCATION_CHANGE_FILTER_DISTANCE 50.0

#define TIME_FOR_MONITORING_LOCAITON_SERVICES_ENABLED .2*60


@interface LocationManager ()

@property (nonatomic, copy) void (^locationCompletion)(CLLocation *loc);

// Monitoring CLLocationServices Enabled
@property (nonatomic, strong) NSTimer *locationServicesEnabledMonitoringTimer;

@end

@implementation LocationManager {
    BOOL notify;
}

@synthesize mostAccurateLocation;

+ (LocationManager *)sharedLocationManager {
    static LocationManager *_sharedLocationManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedLocationManager = [[self alloc] init];
    });
    return _sharedLocationManager;
}

- (LocationManager *)init {
    self = [super init];
    if ( self != nil) {
        shouldSaveCurrentLocationToTripColleciton = NO;
    }
    return self;
}

- (void)dealloc {
    [self stopMonitoringLocationServices];
}

#pragma mark - Getters

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization];
        }
    }

    return _locationManager;
}

#pragma mark - Setters

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.locationCompletion) {
        self.locationCompletion(currentLocation);
        self.locationCompletion = nil;
    }
    _currentLocation = currentLocation;
}

#pragma mark - Location Manager

- (void)startUpdatingLocationNotify:(BOOL)_notify {
    notify = _notify;
    [self.locationManager startUpdatingLocation];
    [self startMonitoringLocationServices];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startUpdatingMostAccurateLocation];
    }
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocaitonManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationDistance metersApart = [location distanceFromLocation:self.currentLocation];
    self.currentLocation = location;
    
    // Update the Mst Accurate Location
    [self updateMostAccurateLocation:self.currentLocation];
    
    // If we are collecting Trip Points, then make sure to save the currentLocaiton to our Trip Points Array
    if ( shouldSaveCurrentLocationToTripColleciton ) {
        [[TripManager sharedTripManager] addTripPointToCache:self.currentLocation];
        [pointsForTrip addObject:self.currentLocation];
    }
    
    if (metersApart > DEFAULT_LOCATION_CHANGE_FILTER_DISTANCE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATIONCHANGE object:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self startUpdatingMostAccurateLocation];
    }
}

#pragma mark - Most Accurate Locations

// This doesn't seem to be used anywhere ...b
//- (void)moveCity:(NSTimer *)timer {
//    [gpsAccuracyTimer invalidate];
//    gpsAccuracyTimer = nil;
//}

- (void)startUpdatingMostAccurateLocation {
    // If we are restarting the GPS Accuracy Timer, then we need to invalidate the old one
    if (notify && gpsAccuracyTimer.isValid) {
        [gpsAccuracyTimer invalidate];
    }
    gpsAccuracyTimer = [NSTimer scheduledTimerWithTimeInterval:GPS_ACCURACY_TIMER_TIMEOUT_TIME target:self selector:@selector(postFoundLocationNotification) userInfo:nil repeats:NO];
}

- (void)updateMostAccurateLocation:(CLLocation*)location {
    // If the GPS Accuracy Timer is still ACTIVE, then 
    if (gpsAccuracyTimer) {
        // If the mostAccurateLocaiton has not been set
        if (self.mostAccurateLocation == nil)
            mostAccurateLocation = location;
       
        // If the new location is MORE Acurate, then we should rpelac eit
        if (self.mostAccurateLocation.horizontalAccuracy > location.horizontalAccuracy)
            mostAccurateLocation = location;
        
        // If our Horizontal Accuracy is within our limit in meters, and not Zero (which would be an invalid result)
        if (self.mostAccurateLocation.horizontalAccuracy <= MINIMUM_GPS_HORIZONTAL_ACCURACY && self.mostAccurateLocation.horizontalAccuracy != 0) {
            // Post a Notification indicating that we have found a location of sufficient accuracy
            [self postFoundLocationNotification];
            
            // Set a Distance Filter so that we only update
            [self.locationManager setDistanceFilter:DISTANCE_FILTER];
        }
    }
}

- (void)postFoundLocationNotification {
    // Invlidate the old GPS Accuracy Timer
    if (gpsAccuracyTimer && gpsAccuracyTimer.isValid) {
        [gpsAccuracyTimer invalidate];
        gpsAccuracyTimer = nil;
    }
    
    // If we are to notify the User aAND we have managed to find a siffuciently accurate location
    if (notify) {
        if (mostAccurateLocation) {
            notify = NO;
            NSMutableDictionary *userInfoDictionary = [[NSMutableDictionary alloc] init];
            [userInfoDictionary setObject:mostAccurateLocation forKey:@"Location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FOUNDLOCATION object:nil userInfo:userInfoDictionary];
        }
        else {
            notify = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE object:nil userInfo:nil];
            [self startUpdatingLocationNotify:YES];
        }
    }
}

- (void)getLocation:(void (^)(CLLocation *loc))completion {
    if (!completion) return;
    
    if (self.currentLocation) completion(self.currentLocation);
    else self.locationCompletion = completion;
}

#pragma mark - Monitoring CLLocation Services

- (void)startMonitoringLocationServices {
    self.locationServicesEnabledMonitoringTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_FOR_MONITORING_LOCAITON_SERVICES_ENABLED target:self selector:@selector(determineLocationServicesAreEnabled) userInfo:nil repeats:YES];
}

- (void)stopMonitoringLocationServices {
    [self.locationServicesEnabledMonitoringTimer invalidate];
    self.locationServicesEnabledMonitoringTimer = nil;
}

- (void)determineLocationServicesAreEnabled {
    if ( ![CLLocationManager locationServicesEnabled] ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE object:nil];
    };
}

#pragma mark - CLVisit

- (void)startMonitoringVisits {
    if ([self.locationManager respondsToSelector:@selector(startMonitoringVisits)]) {
        [self.locationManager startMonitoringVisits];
    }
}

- (void)stopMonitoringVisits {
    if ([self.locationManager respondsToSelector:@selector(stopMonitoringVisits)]) {
        [self.locationManager stopMonitoringVisits];
    }
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {

    //UILocalNotification *n = [[UILocalNotification alloc] init];
    //n.alertBody = @"you visited somewhere!. Sending to Splunk!!!!!!";
    //n.soundName = UILocalNotificationDefaultSoundName;
    //n.fireDate = [NSDate date];
    //[[UIApplication sharedApplication] scheduleLocalNotification:n];
    
    // Save it to the phone
    
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //NSManagedObjectContext *context = [appDelegate managedObjectContext];
    /*
    NSManagedObject *newVisit;
    newVisit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit" inManagedObjectContext:context];
    [newVisit setValue:[NSNumber numberWithDouble:visit.coordinate.latitude] forKey:@"latitude"];
    [newVisit setValue:[NSNumber numberWithDouble:visit.coordinate.longitude] forKey:@"longitude"];
    [newVisit setValue:visit.departureDate forKey:@"date"];
    [newVisit setValue:[NSDate date] forKey:@"timeStamp"];
    */
    
    
    // Format CLVisit for MINT and send it as CLVisit event
    
    NSString *latString = [NSString stringWithFormat:@"%.20f", visit.coordinate.latitude];
    NSString *lngString = [NSString stringWithFormat:@"%.20f", visit.coordinate.longitude];
    
    ExtraData *lat = [[ExtraData alloc] initWithKey:@"latitude"  andValue:latString];
    ExtraData *lng = [[ExtraData alloc] initWithKey:@"longitude"  andValue:lngString];
    ExtraData *departure = [[ExtraData alloc] initWithKey:@"departure_date"  andValue:visit.departureDate.description];
    ExtraData *arrival = [[ExtraData alloc] initWithKey:@"arrival_date"  andValue:visit.arrivalDate.description];
    
    [[Mint sharedInstance] addExtraData:lat];
    [[Mint sharedInstance] addExtraData:lng];
    [[Mint sharedInstance] addExtraData:arrival];
    [[Mint sharedInstance] addExtraData:departure];

    [[Mint sharedInstance] logEventAsyncWithTag:@"CLVisit" completionBlock:nil];
    [[Mint sharedInstance] clearExtraData];

    
    //NSError *error;
    //[context save:&error];
}

#pragma mark - Collecting Points for Trip Models

- (void)startCollectingPointsForTrip {
    // Instnatiate an Empty Array for the Trip Points
    pointsForTrip = nil;
    pointsForTrip = [[NSMutableArray alloc] init];
    
    // Set the BOOL that determines that we should be collecting Point
    shouldSaveCurrentLocationToTripColleciton = YES;
}

- (NSArray *)stopCollectingPointsForTrip {
    // Set the BOOL that determines that we should be collecting Point
    shouldSaveCurrentLocationToTripColleciton = NO;
    
    // Return the Points for the Current Trip
    return pointsForTrip;
}

#pragma mark - API Calls

+ (void)getAddressForLat:(CGFloat)lat andLng:(CGFloat)lng completion:(void (^)(NSString *address))completion {
    NSString *requestString = [NSString stringWithFormat:@"%@directions/reverse-geocode/?api_key=%@&lat=%f&lng=%f&direction_api=mapbox", API_URL, API_KEY, lat, lng];
    
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSString *result = [JSON stringForKey:@"result"];
        if (result) {
            completion(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        RSLog(@"%@: %@", error, error.userInfo);
        completion(nil);
    }];
    [operation start];
}

+ (void)getLatLngForAddress:(NSString *)address completion:(void (^)(CLLocation *loc))completion {
    NSString *requestString = [NSString stringWithFormat:@"%@directions/geocode-address/?api_key=%@&address=%@", API_URL, API_KEY, address];
    
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSString *latLngString = [JSON stringForKey:@"result"];
        NSArray *components = [latLngString componentsSeparatedByString:@","];
        CGFloat lat = [[components objectAtIndex:0] floatValue];
        CGFloat lng = [[components objectAtIndex:1] floatValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        if (completion) completion(loc);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        RSLog(@"%@: %@", error, error.userInfo);
        completion(nil);
    }];
    [operation start];
}

+ (void)getCityForLat:(CGFloat)lat andLng:(CGFloat)lng completion:(void (^)(NSString *cityName))completion {
    NSString *requestString = [NSString stringWithFormat:@"%@api/city/get/?api_key=%@&lat=%f&lng=%f&direction_api=mapbox", API_URL, API_KEY, lat, lng];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSDictionary *resultDictionary = [JSON objectForKey:@"result"];
        if (([resultDictionary class] != [NSNull class]) &&  ([resultDictionary.allKeys containsObject:@"city"]) ) {
            NSString *cityName = [resultDictionary stringForKey:@"city"];
            completion(cityName);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        RSLog(@"%@: %@", error, error.userInfo);
        completion(nil);
    }];
    [operation start];
}

+ (void)checkSupportedCityForLat:(CGFloat)lat andLng:(CGFloat)lng completion:(void(^)(BOOL supported, NSString *cityName))completion {
    NSString *requestString = [NSString stringWithFormat:@"%@city/get/?api_key=%@&lat=%f&lng=%f", API_URL, API_KEY, lat, lng];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSDictionary *resultDict = [JSON dictionaryForKey:@"result"];
        
        NSString *providersEntireString = [resultDict stringForKey:@"providers"];
        NSArray *providerNames = [providersEntireString componentsSeparatedByString:@", "];
        BOOL supported = NO;
        for (NSString *name in providerNames) {
            if ([name isEqualToString:@"bcycle"]) {
                supported = YES;
                break;
            }
        }
        NSString *cityName = [NSString stringWithFormat:@"%@, %@", [resultDict stringForKey:@"city"], [resultDict stringForKey:@"state"]];
        
        if (completion) completion(supported, cityName);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        RSLog(@"%@: %@", error, error.userInfo);
        if (completion) completion(NO, @"");
    }];
    [operation start];
}

@end
