//
//  RSViewController.h
//  RideScout
//
//  Created by Charlie Cliff on 8/20/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSViewController : UIViewController

- (void)presentNoInternetConnectionViewWithCompletion:(void(^)())completion;
- (void)presentNoInternetConnectionView;

- (void)presentNoGeoLocationView;

@end
