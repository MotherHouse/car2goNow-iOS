//
//  NetworkingManager.h
//  Bcycle
//
//  Created by Charlie Cliff on 10/13/15.
//  Copyright © 2015 ridescout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface NetworkingManager : NSObject

+(void) POST:(NSString *)url parameters:(NSDictionary *)params success:(void ( ^ ) ( AFHTTPRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( AFHTTPRequestOperation *operation , NSError *error ))failure;

@end
