//
//  Feature.m
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "Feature.h"
#import <RideKit/NSDictionary+RKParser.h>

@implementation Feature

- (instancetype)initWithDictionary:(NSDictionary *)featureDict {
    self = [super init];
    if (self) {
        [self parseFeatureDictionary:featureDict];
    }
    return self;
}

- (void)parseFeatureDictionary:(NSDictionary *)featureDict {
    self.name = [featureDict stringForKey:@"name"];
    self.uri = [featureDict stringForKey:@"uri"];
    self.type = [featureDict numberForKey:@"type"];
    self.behaviors = [featureDict arrayForKey:@"behaviors"];
}

+ (NSArray *)getFeaturesFromArray:(NSArray *)featuresDictArray {
    NSMutableArray *features = [[NSMutableArray alloc] initWithCapacity:featuresDictArray.count];
    for (NSDictionary *featureDict in featuresDictArray) {
        Feature *newFeature = [[Feature alloc] initWithDictionary:featureDict];
        [features addObject:newFeature];
    }
    return features;
}

- (BOOL)isEqualToFeature:(Feature *)feature {
    if (!feature) {
        return NO;
    }
    
    BOOL haveEqualNames = (!self.name && !feature.name) || [self.name isEqualToString:feature.name];
    BOOL haveEqualURIs = (!self.uri && !feature.uri) || [self.uri isEqualToString:feature.uri];
    BOOL haveEqualTypes = (!self.type && !feature.type) || [self.type isEqualToNumber:feature.type];
    BOOL haveEqualBehaviors = (!self.behaviors && !feature.behaviors) || [self.behaviors isEqualToArray:feature.behaviors];
    
    return haveEqualNames && haveEqualURIs && haveEqualTypes && haveEqualBehaviors;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Feature class]]) {
        return NO;
    }
    
    return [self isEqualToFeature:(Feature *)object];
}

@end
