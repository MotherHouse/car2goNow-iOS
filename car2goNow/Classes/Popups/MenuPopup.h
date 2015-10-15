//
//  PopupMenu.h
//  RideScout
//
//  Created by Charlie Cliff on 7/22/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <RideKit/RKPinPopup.h>
#import "RSLabel.h"

@class MenuPopup;

typedef void (^MenuPopupCallback)(MenuPopup *actionSheet, NSInteger buttonIndex);

@interface MenuPopup : RKPopup

@property (nonatomic, copy) MenuPopupCallback callback;

// UI
@property (nonatomic, strong) RSLabel *subTitleLabel;
@property (nonatomic) BOOL *shouldDisplayActionItemSeparators;

// Action Items
@property (nonatomic, strong, readonly) NSArray *actionTitles;
@property (nonatomic, strong, readonly) NSMutableArray *actionLabels;

// Setters
- (void)setActionTitles:(NSArray *)inputActionTitles;
- (void)setSubTitleHidden:(BOOL)subTitleIsHidden;

@end
