//
//  RSHTTPRequestOperation.m
//  Bcycle
//
//  Created by Jason Dimitriou on 10/12/15.
//  Copyright © 2015 ridescout. All rights reserved.
//

#import "RSHTTPRequestOperation.h"

@implementation RSHTTPRequestOperation

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }
    
    self.shouldTryAgainUponFailure = YES;
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return self;
}


- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation * _Nonnull, id _Nonnull))success failure:(void (^)(AFHTTPRequestOperation * _Nonnull, NSError * _Nonnull))failure {
    
//    void (^failureWithPopup)(AFHTTPRequestOperation * _Nonnull, NSError * _Nonnull) = ^void(, NSError * _Nonnull) {
//        failure(failureWithPopup);
//    };
    
    [super setCompletionBlockWithSuccess:success failure:failure];
}

@end
