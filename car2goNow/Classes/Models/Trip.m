//
//  Trip.m
//  RideScout
//
//  Created by Charlie Cliff on 7/20/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Trip.h"

#import <RideKit/NSDictionary+RKParser.h>

#define KEY_USER @"user"
#define KEY_TRIP_ID @"id"
#define KEY_CANCELLED @"cancelled"
#define KEY_START @"start"
#define KEY_END @"end"

#define KEY_LOCATION @"location"
#define KEY_TIME @"time"
#define KEY_TOTAL_DISTANCE @"total_distance"
#define KEY_TRIP_POINTS @"trip_points"

#define KEY_PAYMENT @"payment"
#define KEY_BASE_FARE @"base_fare"
#define KEY_FINAL_FARE @"final_fare"
#define KEY_CURRENCY @"currency"
#define KEY_PAID @"paid"
#define KEY_PAYMENT_BREAKDOWN @"payment_breakdown"
#define KEY_PAYMENT_CC @"payment_cc"
#define KEY_PAYMENT_TYPE @"payment_type"
#define KEY_PAYMENT_CREATED @"payment_created"

#define KEY_PROVIDER_DATA @"provider_data"

@implementation Trip

- (instancetype)initWithDictionary:(NSDictionary *)profileDictionary {
    self = [super init];
    if (self) {
        [self parseDictionary:profileDictionary];
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)tripDictionary {
    
    // Trip Identification Data
    self.userName = [tripDictionary objectForKey:KEY_USER];
    self.tripID = [tripDictionary objectForKey:KEY_TRIP_ID];
    
    // When (and IF) the Trip Was Cancelled
    NSString *cancelledDateStr = [tripDictionary objectForKey:KEY_CANCELLED];
    if ( cancelledDateStr != (id)[NSNull null] ) {
        self.cancelled = [self parseDateString:cancelledDateStr];
    }
    
    // Trip Start Data
    NSDictionary *startDict = [tripDictionary objectForKey:KEY_START];
    NSString *startDateStr = [startDict objectForKey:KEY_TIME];
    if ( startDateStr != (id)[NSNull null] ) {
        self.startTime = [self parseDateString:startDateStr];
    }
    
    // Trip End Data
    NSDictionary *endDict = [tripDictionary objectForKey:KEY_END];
    NSString *endDateStr = [endDict objectForKey:KEY_TIME];
    if ( endDateStr != (id)[NSNull null] ) {
        self.endTime = [self parseDateString:endDateStr];
    }
    
    // Trip Geo-Location Data
    self.totalDistance = [endDict objectForKey:KEY_TOTAL_DISTANCE];
    self.tripPoints = [endDict objectForKey:KEY_TRIP_POINTS];
  
    // Payment Data
    NSDictionary *paymentDict = [tripDictionary objectForKey:KEY_PAYMENT];
    self.baseFare = [paymentDict objectForKey:KEY_BASE_FARE];
    self.finalFare = [paymentDict objectForKey:KEY_FINAL_FARE];
    self.currency = [paymentDict objectForKey:KEY_CURRENCY];
    self.paid = [paymentDict boolForKey:KEY_PAID];
    
    self.paymentBreakdown = [paymentDict objectForKey:KEY_PAYMENT_BREAKDOWN]; // WTF is this EVEN going to be?
    self.paymentCreditCard = [paymentDict objectForKey:KEY_PAYMENT_CC]; // WTF is this EVEN going to be?
    self.paymentType = [[paymentDict objectForKey:KEY_PAYMENT_TYPE] integerValue];
    
    NSString *paymentDateStr = [paymentDict objectForKey:KEY_PAYMENT_CREATED];
    self.paymentCreated = [self parseDateString:paymentDateStr];
    
    // Provider Data
    self.providerData = [tripDictionary dictionaryForKey:KEY_PROVIDER_DATA];
    
}

- (NSDate *)parseDateString:(NSString *) dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

@end
