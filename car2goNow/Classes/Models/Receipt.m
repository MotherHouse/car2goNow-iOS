//
//  Receipt.m
//  RideScout
//
//  Created by Charlie Cliff on 8/6/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Receipt.h"
#import <RideKit/RKCreditCard.h>
#import <RideKit/NSDictionary+RKParser.h>

#define KEY_FOR_TAX @"tax"
#define KEY_FOR_NET_FARE @"net"
#define KEY_FOR_FINAL_FARE @"total"
#define KEY_FOR_USER_COST @"user_cost"
#define KEY_FOR_RECEIPT_CODE @"receipt_number"
#define KEY_FOR_PROVIDER @"provider"
#define KEY_FOR_TRANSACTIONDATE @"payment_date"
#define KEY_FOR_PAYMENTINFO @"payment_info"

@implementation Receipt

- (instancetype)initWithDictionary:(NSDictionary *)profileDictionary {
    self = [super init];
    if (self) {
        [self parseDictionary:profileDictionary];
    }
    return self;
}

- (instancetype)initWithLittlePatienceForBackendEndpoint {
    self = [super init];
    if (self) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
        NSInteger day = (arc4random_uniform(24) + 1);
        [dateComponents setDay:day];
        NSInteger month = (arc4random_uniform(5) + 1);
        [dateComponents setMonth:month];
        [dateComponents setYear:2013];
        NSDate *date = [calendar dateFromComponents:dateComponents];
        self.transactionDate = date;
        
        self.totalCost = [NSNumber numberWithFloat:16.56];
        self.userCost = [NSNumber numberWithFloat:13.56];
        self.rideScoutCost = nil;
        self.tax = [NSNumber numberWithFloat:3];
        self.maskedCreditCardNumber = nil;
        self.creditCardType = nil;
        self.provider = @"car2go";
        self.receiptCode = @"pedicaboEgoVosEtIrrumabo";
        
    }
    return self;
}


- (void)parseDictionary:(NSDictionary *)tripDictionary {
        
    NSString *transactionDateStr = [tripDictionary stringForKey:KEY_FOR_TRANSACTIONDATE];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    
    self.transactionDate = [df dateFromString:transactionDateStr];
    
    self.totalCost = [tripDictionary numberForKey:KEY_FOR_FINAL_FARE];
    self.userCost = [tripDictionary numberForKey:KEY_FOR_NET_FARE];
    self.rideScoutCost = nil;
    self.tax = [tripDictionary numberForKey:KEY_FOR_TAX];
    self.provider = [tripDictionary stringForKey:KEY_FOR_PROVIDER];
    self.receiptCode = [tripDictionary stringForKey:KEY_FOR_RECEIPT_CODE];
    
    NSDictionary *creditCardDict = [tripDictionary objectForKey:KEY_FOR_PAYMENTINFO];
    self.creditCard = [[RKCreditCard alloc] initWithDictionary:creditCardDict];
    
}

#pragma mark - Getters

- (NSString *)getProviderName {
    return self.provider;
}

@end
