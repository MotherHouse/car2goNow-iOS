//
//  TripManager.m
//  RideScout
//
//  Created by Charlie Cliff on 7/21/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "Trip.h"
#import "TripManager.h"
#import "LocationManager.h"

#import "Receipt.h"

#import <RideKit/NSDictionary+RKParser.h>
#import "constantsAndMacros.h"

#if PRINT_API_ERRORS
#import "MessagePopup.h"
#endif

#define RECEIPT_HISTPRY_ENDPOINT @"trip/history/"
#define HITME_ENDPOINT @"trip/hitme/"
#define RECEIPT_EMAIL_ENDPOINT @"payment/receipts/send/"

@interface TripManager ()

@end

@implementation TripManager

#pragma mark - Init

+ (TripManager *)sharedTripManager {
    static TripManager *_sharedTripManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedTripManager = [[self alloc] init];
    });
    return _sharedTripManager;
}

- (instancetype)init {
    self = [super init];
    if (self!=nil) {
        _receipts = [[NSMutableArray alloc] init];
        _currentTripPoints = [[NSMutableArray alloc] init];
        _monthsThatHaveReceipts = [[NSMutableArray alloc] init];
        _receiptsGroupedByMonth= [[NSMutableDictionary alloc] init];
        [self getMostRecentReceipts:[NSNumber numberWithDouble:DEFAULT_NUMBER_OF_RECEIPTS_TO_FETCH] ];
    }
    return self;
}

- (void)setReceipts:(NSMutableArray *)inputReceipts {
    _receipts = inputReceipts;
    [[NSNotificationCenter defaultCenter] postNotificationName:TRIP_NOTIFICATION_RECEIPTS_DID_UPDATE object:nil userInfo:nil];
}

#pragma mark - Trip Management

- (void)startTrip {
    [[LocationManager sharedLocationManager] startCollectingPointsForTrip];
}

- (void)startTrip:(Trip *)newTrip {
    
    self.currentTripID = newTrip.tripID;
    [self startTrip];
}

- (void)stopTrip {
    [[LocationManager sharedLocationManager] stopCollectingPointsForTrip];
    [TripManager updateTripWithID:self.currentTripID withTripPoints:self.currentTripPoints withSuccess:^{
        
    } WithErrorHandler:^{
        
    }];
//    [self.currentTripPoints removeAllObjects];
}

- (void)addTripPointToCache:(CLLocation *)currentPoint {
    [self.currentTripPoints addObject:currentPoint];
    if ( self.currentTripPoints.count >= TRIP_POINT_CACHE_COUNT ) {
        [TripManager updateTripWithID:self.currentTripID withTripPoints:self.currentTripPoints withSuccess:^{
            
        } WithErrorHandler:^{
            
        }];
    }
}

#pragma mark - Receipt Management

/**
 * Group the Receipts in the Event Dictionary based on their Month
 */

- (void) sortReceiptsByMonth
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    for (Receipt *receipt in self.receipts) {
        NSDate *receiptDate = receipt.transactionDate;
        NSString *receiptDateAsString = [dateFormatter stringFromDate:receiptDate];
        
        if ( [self.receiptsGroupedByMonth.allKeys containsObject:receiptDateAsString] ){
            NSMutableArray *receiptsThatAreInTheGivenMonth = [self.receiptsGroupedByMonth objectForKey:receiptDateAsString];
            [receiptsThatAreInTheGivenMonth addObject:receipt];
            [self.receiptsGroupedByMonth setObject:receiptsThatAreInTheGivenMonth forKey:receiptDateAsString];
        }
        else {
            NSMutableArray *newEventArray = [[NSMutableArray alloc] initWithObjects:receipt, nil];
            [self.receiptsGroupedByMonth setObject:newEventArray forKey:receiptDateAsString];
        }
    }
    
    NSArray *monthsArray = self.receiptsGroupedByMonth.allKeys;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(caseInsensitiveCompare:)];
    self.monthsThatHaveReceipts= [monthsArray sortedArrayUsingDescriptors:@[sort]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"transactionDate" ascending:NO];
    NSArray *sortedArray = [self.receipts sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.receipts = [NSMutableArray arrayWithArray:sortedArray];
}


#pragma mark - Trip API

+ (void)updateTripWithID:(NSString *)tripID withTripPoints:(NSArray *)tripPoints withSuccess:(void (^)(void))successHandler WithErrorHandler:(void (^)(void))errorHandler {
    
//#if PRINT_API_ERRORS
//    MessagePopup *popup = [[MessagePopup alloc] initWithTitle:@"DEBUG" subTitle:[tripPoints description]];
//    [popup presentPopupFromCenterPoint:CGPointMake(0, 0) completion:nil];
//#endif
    
    // Convert the Coordinates to a String
    NSString *coordinateString = [TripManager convertTripPointToString:tripPoints];
    
    // Set up the Dictionary of the PIN and the VINpo
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tripID forKey:@"trip_id"];
    [params setObject:coordinateString forKey:@"trip_points"];
    
    // Logging
    NSLog(@"updateTripWithID PARAMS - %@", params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@trip/update/?api_key=%@", API_URL, API_KEY] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (successHandler) successHandler();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (errorHandler) errorHandler();
    }];
}

+ (void)HITME {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@?api_key=%@", API_URL, HITME_ENDPOINT, API_KEY];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Receipts

- (void)getMostRecentReceipts:(NSNumber *)receiptLimit {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:receiptLimit forKey:@"limit"];
    NSLog(@"getMostRecentReceipts PARAMS - %@", params);
    
    __block __weak __typeof(self)blockSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestString = [NSString stringWithFormat:@"%@%@?api_key=%@", API_URL, RECEIPT_HISTPRY_ENDPOINT, API_KEY];
    NSLog(@"requestString - %@", requestString);

    [manager GET:requestString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSArray *receiptsArray = [JSON arrayForKey:@"result"];
        
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (int i = 0; i < receiptsArray.count; i++) {
            NSDictionary *receiptData = [receiptsArray objectAtIndex:i];
            NSDictionary *receiptDict = [receiptData dictionaryForKey:@"receipt"];
            Receipt *newReceipt = [[Receipt alloc] initWithDictionary:receiptDict];
            [tmp addObject:newReceipt];
        }
        [blockSelf setReceipts:tmp];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseObject) {
            NSLog(@"getReceiptWithTripId FAILURE - %@", operation.responseString);
        }
        else {
            NSLog(@"getReceiptWithTripId FAILURE - %@", error);
        }
    }];
}

- (void)sendReceipt:(Receipt *)receipt toEmail:(NSString *)email{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:receipt.receiptCode forKey:@"receipt_number"];
    [params setObject:email forKey:@"email"];

    NSString *requestString = [NSString stringWithFormat:@"%@%@?api_key=%@", API_URL, RECEIPT_EMAIL_ENDPOINT, API_KEY];
    NSLog(@"%@", requestString);
    NSLog(@"sendReceipt params: %@", params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Utility Functions

+ (NSString *)convertTripPointToString:(NSArray *)tripPoints {
    // Convert each CLLocation to a Coordinate String
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (CLLocation *tripPoint in tripPoints) {
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        NSString *timeStamp = [dateFormatter stringFromDate:tripPoint.timestamp];
        
        NSString *coordinateString = [NSString stringWithFormat:@"%f,%f,%@", tripPoint.coordinate.latitude, tripPoint.coordinate.longitude, timeStamp];
        [tmpArray addObject:coordinateString];
    }
    
    // Join the Array
    NSString *joinedString = [tmpArray componentsJoinedByString:@";"];
    
    return joinedString;
}

- (NSMutableArray *)parseDictionaryForReceipts:(NSDictionary *)dictionaryOfNewReceipts {

    return nil;
}


//- (void)fabricateBullshitReceipts {
//    
//    for (int i = 0; i < RECEIPT_HISTORY_LIMIT; i++) {
//        Receipt *bullshitReceipt = [[Receipt alloc] initWithLittlePatienceForBackendEndpoint];
//        [self.receipts addObject:bullshitReceipt];
//    }
//    
////    [self sortReceiptsByMonth];
//    [[NSNotificationCenter defaultCenter] postNotificationName:TRIP_NOTIFICATION_RECEIPTS_DID_UPDATE object:nil userInfo:nil];
//}

@end
