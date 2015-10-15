//
//  MapViewController.h
//  RideScout
//
//  Created by Brady Miller on 2/17/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RSViewController.h"
#import <Mapbox-iOS-SDK/Mapbox.h>
#import "Provider.h"

@interface MapViewController : RSViewController <UINavigationControllerDelegate, RMMapViewDelegate>

// State beast
@property (nonatomic, strong) Provider *provider;
@property (nonatomic) ProviderState providerState;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSString *addressStreet;
@property (nonatomic, strong) NSString *addressCityState;

@end
