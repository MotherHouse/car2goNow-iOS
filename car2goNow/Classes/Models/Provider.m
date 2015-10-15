//
//  Provider.m
//  RideScout
//
//  Created by Brady Miller on 2/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Provider.h"
#import <RideKit/NSDictionary+RKParser.h>
#import "constantsAndMacros.h"
#import "Feature.h"
#import <RideKit/RideKit.h>
@interface Provider ()

@property (nonatomic, readwrite) BOOL ridesNearbyNeedUpdate;
@property (nonatomic, readwrite) BOOL selectedRideNeedUpdate;

@end

@implementation Provider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.localRideIconCache = [RideIconsManager sharedCache];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)providerDictionary {
    self = [self init];
    if (self) {
        [self parseDictionary:providerDictionary];
    }
    return self;
}

- (void)parseDictionary:(NSDictionary *)providerDictionary {
    self.name = [providerDictionary stringForKey:@"name"];
    self.slug = [providerDictionary stringForKey:@"slug"];
    
    NSString *colorHex = [providerDictionary stringForKey:@"color"];
    if (colorHex && colorHex.length > 0) self.providerColor = [UIColor colorFromHex:colorHex alpha:0.50];
    
    self.providerDescription = [providerDictionary stringForKey:@"description"];
    self.providerId = [providerDictionary stringForKey:@"id"];
    self.type = [providerDictionary stringForKey:@"type"];
    
    self.providerType = [self getProviderTypeForType:self.type];
    
    NSString *iconUrl = [providerDictionary stringForKey:@"icon"];
    if (iconUrl.length == 0) iconUrl = [NSString stringWithFormat:@"http://ridescout.appspot.com/api/providers/%@/icon.png", self.slug];
    self.iconUrl = iconUrl;
    
    NSMutableArray *features = [NSMutableArray new];
    for (NSDictionary *featureDict in [providerDictionary arrayForKey:@"features"]) {
        RKFeature *feature = [RKFeature buildProviderFeatureFromDictionary:featureDict];
        [features addObject:feature];
    }
    self.features = features;
    
    self.iosNamespace = [providerDictionary stringForKey:@"ios_namespace"];
    self.iosDownload = [providerDictionary stringForKey:@"ios_download"];
    
    CGFloat imageDiam = SCREEN_WIDTH - 40 * 2;
    [self.localRideIconCache addImageForUrl:iconUrl withName:self.name withWidth:imageDiam andHeight:imageDiam];
}

- (enumProviderType)getProviderTypeForType:(NSString *)type {
    return eProviderTypeBikeshare;
}

#pragma mark - Setters for KVO

- (BOOL)isEqualToProvider:(Provider *)provider {
    if (!provider) {
        return NO;
    }
    BOOL haveEqualNames = (!self.name && !provider.name) || [self.name isEqualToString:provider.name];
    BOOL haveEqualColors = (!self.providerColor && !provider.providerColor) || [self.providerColor isEqual:provider.providerColor];
    BOOL haveEqualDescriptions = (!self.providerDescription && !provider.providerDescription) || [self.providerDescription isEqualToString:provider.providerDescription];
    BOOL haveEqualIDs = (!self.providerId && !provider.providerId) || [self.providerId isEqualToString:provider.providerId];
    BOOL haveEqualTypes = (!self.providerType && !provider.providerType) || (self.providerType == provider.providerType);
    BOOL haveEqualIconURLs = (!self.iconUrl && !provider.iconUrl) || [self.iconUrl isEqualToString:provider.iconUrl];
    BOOL haveEqualFeatures = (!self.features && !provider.features) || [self.features isEqualToArray:provider.features];
    BOOL haveEqualIosNamespaces = (!self.iosNamespace && !provider.iosNamespace) || [self.iosNamespace isEqualToString:provider.iosNamespace];
    BOOL haveEqualIosDownloads = (!self.iosDownload && !provider.iosDownload) || [self.iosDownload isEqualToString:provider.iosDownload];
    
    return haveEqualNames && haveEqualColors && haveEqualDescriptions && haveEqualIDs && haveEqualTypes && haveEqualIconURLs && haveEqualFeatures && haveEqualIosNamespaces && haveEqualIosDownloads;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Provider class]]) {
        return NO;
    }
    
    return [self isEqualToProvider:(Provider *)object];
}

#pragma mark - Helpers

- (NSString *)stringByStrippingHTML:(NSString *)s {
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    long newLineStart =[s rangeOfString:@"Destination"].location;
    
    if(newLineStart!=NSNotFound){
        NSMutableString* result = [s mutableCopy];
        [result insertString:@"\n" atIndex:newLineStart];
        return result;
    }
    else
        return s;
}

@end
