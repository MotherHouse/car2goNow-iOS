//
//  BCycleManager.m
//  RideScout
//
//  Created by Charlie Cliff on 7/14/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "BCycleManager.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "constantsAndMacros.h"
#import "MessagePopup.h"
#import "Trip.h"

#import "NetworkingManager.h"

@implementation BCycleManager


+ (void)registerBCycleAccountWithSuccess:(void (^)(void))success WithErrorHandler:(void (^)(NSInteger code))failure {
    // Set up the Dictionary of the PIN and the VIN
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"false" forKey:@"optInEmail"];
    [params setObject:@"false" forKey:@"optInSms"];
    [params setObject:@"false" forKey:@"test"];

    // Instantiate the POST request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@trip/bcycle/register/?api_key=%@", API_URL, API_KEY] parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if PRINT_API_ERRORS
              MessagePopup *popup = [[MessagePopup alloc] initWithTitle:@"DEBUG" subTitle:operation.responseString];
              [popup presentPopupFromCenterPoint:CGPointMake(0, 0) completion:nil];
#endif
              if (success) success();
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if PRINT_API_ERRORS
                MessagePopup *popup = [[MessagePopup alloc] initWithTitle:@"DEBUG" subTitle:operation.responseString];
                [popup presentPopupFromCenterPoint:CGPointMake(0, 0) completion:nil];
#endif
              if ( operation.responseObject ) {
                  NSDictionary *JSON = (NSDictionary *)operation.responseObject;
                  NSInteger errorCode = ([[JSON objectForKey:@"error"] integerValue]);
                  if ( failure ) failure(errorCode);
              }
              else
                  if ( failure ) failure(-1);
          }];
}

+ (void)checkoutBCycleWithDockID:(NSInteger)dockID withKioskID:(NSInteger)kioskID withUserPin:(NSString *)userPin withSuccess:(void (^)(Trip *newTrip))success WithErrorHandler:(void (^)(NSInteger code))failure {
    // Set up the Dictionary of the PIN and the VIN
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInteger:dockID] forKey:@"dockNumber"];
    [params setObject:[NSNumber numberWithInteger:kioskID] forKey:@"kioskId"];
    [params setObject:userPin forKey:@"pin"];
    [params setObject:@"false" forKey:@"test"];
    
    NSString * requestURL = [NSString stringWithFormat:@"%@trip/bcycle/rent/?api_key=%@", API_URL, API_KEY];
    
    NSLog(@"PARAMS %@", params);

    [NetworkingManager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
#if PRINT_API_ERRORS
        MessagePopup *popup = [[MessagePopup alloc] initWithTitle:@"DEBUG" subTitle:operation.responseString];
        [popup presentPopupFromCenterPoint:CGPointMake(0, 0) completion:nil];
#endif
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSDictionary *tripDictionary = [JSON dictionaryForKey:@"result"];
        Trip *newTrip = [[Trip alloc] initWithDictionary:tripDictionary];
        
        if (success) success(newTrip);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
#if PRINT_API_ERRORS
        MessagePopup *popup = [[MessagePopup alloc] initWithTitle:@"DEBUG" subTitle:operation.responseString];
        [popup presentPopupFromCenterPoint:CGPointMake(0, 0) completion:nil];
#endif
        if ( operation.responseObject ) {
            NSDictionary *JSON = (NSDictionary *)operation.responseObject;
            NSInteger errorCode = ([[JSON objectForKey:@"error"] integerValue]);
            if ( failure ) failure(errorCode);
        }
        else
            if ( failure ) failure(-1);
    }];
    
//    // Instantiate the POST request
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager POST: parameters:params
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//#if PRINT_API_ERRORS
//              MessagePopup *popup = [[MessagePopup alloc] initWithTitle:@"DEBUG" subTitle:operation.responseString];
//              [popup presentPopupFromCenterPoint:CGPointMake(0, 0) completion:nil];
//#endif
//              NSDictionary *JSON = (NSDictionary *)responseObject;
//              NSDictionary *tripDictionary = [JSON dictionaryForKey:@"result"];
//              Trip *newTrip = [[Trip alloc] initWithDictionary:tripDictionary];
//              
//              if (success) success(newTrip);
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//#if PRINT_API_ERRORS
//              MessagePopup *popup = [[MessagePopup alloc] initWithTitle:@"DEBUG" subTitle:operation.responseString];
//              [popup presentPopupFromCenterPoint:CGPointMake(0, 0) completion:nil];
//#endif
//              if ( operation.responseObject ) {
//                  NSDictionary *JSON = (NSDictionary *)operation.responseObject;
//                  NSInteger errorCode = ([[JSON objectForKey:@"error"] integerValue]);
//                  if ( failure ) failure(errorCode);
//              }
//              else
//                  if ( failure ) failure(-1);
//          }];
}

@end
