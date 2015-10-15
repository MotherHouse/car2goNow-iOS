//
//  TripManager.h
//  RideScout
//
//  Created by Charlie Cliff on 7/21/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TRIP_POINT_CACHE_COUNT 15
#define RECEIPT_HISTORY_LIMIT 10.0

#define DEFAULT_NUMBER_OF_RECEIPTS_TO_FETCH 4.0

#define TRIP_NOTIFICATION_RECEIPTS_DID_UPDATE @"Trip Manager Receipts Did Update"

typedef NS_ENUM(NSInteger, tripProvider){
    bCycleTripProvider
};

typedef NS_ENUM(NSInteger, tripState){
    tripIsInProgress = 0,
    tripIsEnded
};

@class Trip;
@class CLLocation;
@class Receipt;

@interface TripManager : NSObject

@property (nonatomic, strong) NSArray *monthsThatHaveReceipts;
@property (nonatomic, strong) NSMutableDictionary *receiptsGroupedByMonth;


@property (nonatomic, strong) NSMutableArray *receipts;
@property (nonatomic, strong) NSMutableDictionary *receiptsIndexedByReceiptID;

@property (nonatomic, strong) NSString *currentTripID; // Can be circumvented with cooperation form the backend...
@property (nonatomic, strong) NSMutableArray *currentTripPoints;

+ (TripManager *)sharedTripManager;

// Trip Management
- (void)startTrip;
- (void)startTrip:(Trip *)newTrip;
- (void)stopTrip;
- (void)addTripPointToCache:(CLLocation *)currentPoint;

// Trip API Calls
//- (void)getTripWithTripId:(NSString *)tripID;
//- (void)getTripsForMonth:(NSNumber *)epochTimeOfTheMonth; // ...phrasing?
//- (void)getTripsForProvider:(tripProvider *)tripProvider;
+ (void)updateTripWithID:(NSString *)tripID withTripPoints:(NSArray *)tripPoints withSuccess:(void (^)(void))successHandler WithErrorHandler:(void (^)(void))errorHandler;
+ (void)HITME;

// Receipt API Calls
- (void)getMostRecentReceipts:(NSNumber *)receiptLimit;
- (void)sendReceipt:(Receipt *)receipt toEmail:(NSString *)email;

// Utility Functions
+ (NSString *)convertTripPointToString:(NSArray *)tripPoints;


//- (void)fabricateBullshitReceipts;

@end
