//
//  BCycleManager.h
//  RideScout
//
//  Created by Charlie Cliff on 7/14/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"

@class Trip;

@interface BCycleManager : NSObject

+ (void)registerBCycleAccountWithSuccess:(void (^)(void))success WithErrorHandler:(void (^)(NSInteger code))failure;
+ (void)checkoutBCycleWithDockID:(NSInteger)dockID withKioskID:(NSInteger)kioskID withUserPin:(NSString *)userPin withSuccess:(void (^)(Trip *newTrip))success WithErrorHandler:(void (^)(NSInteger code))failure;
@end
