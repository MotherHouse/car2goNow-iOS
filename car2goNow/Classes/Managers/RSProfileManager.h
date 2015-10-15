//
//  RSProfileManager.h
//  RideScout
//
//  Created by Charlie Cliff on 9/24/15.
//  Copyright © 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RideKit/RideKit.h>
#import "RSProfile.h"

#define RS_PROFILE_UPDATE_NOTIFICATION @"I HAVE THE POWER!!!"

@interface RSProfileManager : NSObject

@property (nonatomic, strong, readonly) RSProfile *profile;

+ (RSProfileManager *)sharedManager;

- (void)getProfileWithSuccess:(void (^)(void))success failure:(void (^)(void))failure;
- (void)deleteProfileWithSuccess:(void (^)(void))success failure:(void (^)(void))failure;
- (void)updateProfileImage:(UIImage *)image withSuccess:(void (^)(void))success failure:(void (^)(void))failure;
- (void)updateProfileEmail:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(void))failure;
- (void)updateProfileForParameters:(NSMutableDictionary *)parameters withSuccess:(void (^)(void))success failure:(void (^)(void))failure;

@end
