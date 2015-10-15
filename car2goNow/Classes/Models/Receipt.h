//
//  Receipt.h
//  RideScout
//
//  Created by Charlie Cliff on 8/6/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKCreditCard;

@interface Receipt : NSObject

@property(nonatomic, strong) NSDate *transactionDate;
@property(nonatomic, strong) NSNumber *totalCost;
@property(nonatomic, strong) NSNumber *userCost;
@property(nonatomic, strong) NSNumber *rideScoutCost;
@property(nonatomic, strong) NSNumber *tax;
@property(nonatomic, strong) NSString *maskedCreditCardNumber;
@property(nonatomic, strong) NSString *creditCardType;
@property(nonatomic, strong) NSString *provider;
@property(nonatomic, strong) NSString *receiptCode;

@property(nonatomic, strong) RKCreditCard *creditCard;

- (instancetype)initWithDictionary:(NSDictionary *)profileDictionary;
- (instancetype)initWithLittlePatienceForBackendEndpoint;

- (NSString *)getProviderName;



@end
