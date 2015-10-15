//
//  RSProfileManager.m
//  RideScout
//
//  Created by Charlie Cliff on 9/24/15.
//  Copyright © 2015 RideScout. All rights reserved.
//

#import "RSProfileManager.h"
#import "RSProfile.h"
#import <AFNetworking/AFNetworking.h>
#import "constantsAndMacros.h"

#define URL_FOR_PIN_UPDATE      @"%@auth/pin/?api_key=%@"
#define URL_FOR_PROFILE_UPDATE  @"%@auth/profile/?api_key=%@"
#define URL_FOR_PROFILE_GET     @"%@auth/profile/?api_key=%@"
#define URL_FOR_PROFILE_DELETE  @"%@auth/profile/?api_key=%@"

@implementation RSProfileManager

+ (RSProfileManager *)sharedManager {
    static RSProfileManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager getProfileWithSuccess:nil failure:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_sharedManager selector:@selector(refreshRKProfile) name:RKPROFILE_DID_UPDATE_NOTIFICATION object:nil];
    });
    return _sharedManager;
}

#pragma mark - Setters

- (void)setProfile:(RSProfile *)profile {
    _profile = profile;
    [[NSNotificationCenter defaultCenter] postNotificationName:RS_PROFILE_UPDATE_NOTIFICATION object:nil];
}

#pragma mark - Profile API Calls

- (void)refreshRKProfile {
    [self getProfileWithSuccess:nil failure:nil];
}

- (void)getProfileWithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSString *requestString = [NSString stringWithFormat:URL_FOR_PROFILE_GET, API_URL, [[RKManager sharedService] apiKey]];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block __weak __typeof__(self) blockSelf = self;
    [manager GET:escapedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *JSON = (NSDictionary *)responseObject;
            NSDictionary *profileDict = [JSON dictionaryForKey:@"result"];
            RSProfile *newProfile = [[RSProfile alloc] initWithDictionary:profileDict];
            [blockSelf setProfile:newProfile];
            [blockSelf getProfileImagewithSuccess:nil failure:nil];
            if (success) success();
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure();
    }];
}

- (void)getProfileImagewithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSString *urlStringWithSize = [NSString stringWithFormat:@"https://beta.gateway.ridescout.com%@?width=44&height=44", self.profile.imageUrl];
    NSURL *url = [[NSURL alloc] initWithString:urlStringWithSize];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    __block __weak __typeof__(self) blockSelf = self;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = responseObject;
            [blockSelf.profile setImage:image];
            [[NSNotificationCenter defaultCenter] postNotificationName:RS_PROFILE_UPDATE_NOTIFICATION object:nil];
            if (success) success();
            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure();
    }];
    [operation start];
}

- (void)deleteProfileWithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSString *requestString = [NSString stringWithFormat:URL_FOR_PROFILE_DELETE, API_URL, [[RKManager sharedService] apiKey]];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.profile.email forKey:@"email"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block __weak __typeof__(self) blockSelf = self;
    [manager DELETE:escapedString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *JSON = (NSDictionary *)responseObject;
            NSDictionary *profileDict = [JSON dictionaryForKey:@"result"];
            RSProfile *newProfile = [[RSProfile alloc] initWithDictionary:profileDict];
            [blockSelf setProfile:newProfile];
            if (success) success();
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure();
    }];
}


- (void)updateProfileForParameters:(NSMutableDictionary *)parameters withSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSString *requestString = [NSString stringWithFormat:URL_FOR_PROFILE_UPDATE, API_URL, [[RKManager sharedService] apiKey]];
    NSString *escapedString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    __block __weak __typeof(self)blockSelf = self;
    [manager PUT:escapedString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSDictionary *profileDict = [JSON dictionaryForKey:@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RSProfile *newProfile = [[RSProfile alloc] initWithDictionary:profileDict];
            [blockSelf setProfile:newProfile];
            if (success) success();
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Update profile Request Failed with Error: %@, %@ with parameters: %@", error, error.userInfo, parameters);
        if (failure) failure();
    }];
}

- (void)updateProfileImage:(UIImage *)image withSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [[RKManager sharedService] updateProfileImage:image withSuccess:success failure:failure];
}

- (void)updateProfileEmail:(NSString *)email withSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"new_email":email}];
    [[RSProfileManager sharedManager] updateProfileForParameters:parameters withSuccess:^{
        if (success) success();
    } failure:^{
        if (failure) failure();
    }];
}

@end
