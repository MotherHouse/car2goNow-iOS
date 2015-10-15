//
//  NetworkingManager.m
//  Bcycle
//
//  Created by Charlie Cliff on 10/13/15.
//  Copyright © 2015 ridescout. All rights reserved.
//

#import "NetworkingManager.h"
#import "constantsAndMacros.h"

@implementation NetworkingManager

+(void) POST:(NSString *)url parameters:(NSDictionary *)params success:(void ( ^ ) ( AFHTTPRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( AFHTTPRequestOperation *operation , NSError *error ))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) success(operation, responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

              NSInteger errorCode = error.code;
              if ((errorCode < -998) || (errorCode > -1021)) {
                  [[NSNotificationCenter defaultCenter] postNotificationName:AFNETWORKUNREACHABLE object:nil];
              }
              else {
                  if ( failure ) failure(operation,  error);
              }
          }];
}

@end
