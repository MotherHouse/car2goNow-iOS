//
//  ProfileWidgetData.h
//  RideScout
//
//  Created by Jason Dimitriou on 6/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProfileCellData : NSObject

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *subTitleString;
@property (nonatomic, strong) NSString *detailString;

@property (nonatomic) BOOL titleActionable;
@property (nonatomic) BOOL subTitleActionable;
@property (nonatomic) BOOL detailActionable;

@property (nonatomic) BOOL cellActionable;
@property (nonatomic, strong) UIImage *icon;

@end
