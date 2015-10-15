//
//  RideIconsManager.m
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RideIconsManager.h"
#import "AFNetworking.h"
#import "constantsAndMacros.h"
#import "MintManager.h"

@interface RideIcon : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *imageIcon;

@end

@implementation RideIcon
@end

@interface RideIconsManager ()

@property (nonatomic, strong) NSMutableDictionary *rideIcons;
@property (nonatomic, strong) NSMutableDictionary *rideIconsIndexedByProviderName;
@property (nonatomic, strong) NSMutableDictionary *rideIconsExpireDateDict;

@end

@implementation RideIconsManager

+ (RideIconsManager *)sharedCache {
    static RideIconsManager *_sharedCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedCache = [[self alloc] init];
    });
    return _sharedCache;
}

- (NSMutableDictionary *)rideIcons {
    if (!_rideIcons) {
        _rideIcons = [[NSMutableDictionary alloc] init];
        _rideIconsIndexedByProviderName = [[NSMutableDictionary alloc] init];
    }
    return _rideIcons;
}

- (NSMutableDictionary *)rideIconsExpireDateDict {
    if (!_rideIconsExpireDateDict) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _rideIconsExpireDateDict = [[defaults objectForKey:@"RideIconsExpireDateDict"] mutableCopy];
        if (!_rideIconsExpireDateDict) _rideIconsExpireDateDict = [NSMutableDictionary new];
    }
    return _rideIconsExpireDateDict;
}

#pragma mark - Image Managing

- (void)addImageForUrl:(NSString *)urlString withName:(NSString *)name withWidth:(int)width andHeight:(int)height {
    if ([self rideIconExistsForUrl:urlString]) return;
    [MintManager splunkWithString:ADD_IMAGE event:NO breadcrumb:YES];
    
    RideIcon *newRideIcon = [[RideIcon alloc] init];
    newRideIcon.url = urlString;
    [self.rideIcons setObject:newRideIcon forKey:urlString];
    [self.rideIconsIndexedByProviderName setObject:newRideIcon forKey:name];
    
    NSDate *expireDate = [self.rideIconsExpireDateDict objectForKey:[NSString stringWithFormat:@"%@ExpireDate", name]];
    if (expireDate && [[NSDate date] timeIntervalSinceDate:expireDate] < 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    newRideIcon.imageIcon = image;
                    [[NSNotificationCenter defaultCenter] postNotificationName:urlString object:nil];
                }
            });
        });
    }
    else {
        NSString *urlStringWithSize = [NSString stringWithFormat:@"%@?width=%d&height=%d", urlString, width, height];
        NSURL *url = [[NSURL alloc] initWithString:urlStringWithSize];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        __weak __typeof__(self) weakSelf = self;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = responseObject;
                newRideIcon.imageIcon = image;
                [[NSNotificationCenter defaultCenter] postNotificationName:urlString object:nil];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = UIImagePNGRepresentation(image);
                    BOOL writeSuccess = [imageData writeToFile:filePath atomically:YES];
                    if (writeSuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Make expiry date a week from now.
                            NSDate *expireDate = [[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 7];
                            [self.rideIconsExpireDateDict setObject:expireDate forKey:[NSString stringWithFormat:@"%@ExpireDate", name]];
                            [[NSUserDefaults standardUserDefaults] setObject:self.rideIconsExpireDateDict forKey:@"RideIconsExpireDateDict"];
                        });
                    }
                });
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            RSLog(@"RideIconImages failed to load image from: %@, with Error:%@", urlString, [error localizedDescription]);
            [weakSelf.rideIcons removeObjectForKey:urlString];
        }];
        [operation start];
    }
}

- (BOOL)rideIconExistsForUrl:(NSString *)url {
    UIImage *image = [self.rideIcons objectForKey:url];
    if (image) return YES;
    else return NO;
}

- (UIImage *)imageIconForURL:(NSString *)urlString {
    RideIcon *rideIcon = [self.rideIcons objectForKey:urlString];
    return rideIcon.imageIcon;
}

- (UIImage *)imageIconForProviderWithName:(NSString *)name {
    NSString *lowerCaseName = [name lowercaseString];
    if ( [self.rideIconsIndexedByProviderName.allKeys containsObject:lowerCaseName] ) {
        RideIcon *rideIcon = [self.rideIconsIndexedByProviderName objectForKey:lowerCaseName];
        return rideIcon.imageIcon;
    }
    else {
        return nil;
    }
}

@end
