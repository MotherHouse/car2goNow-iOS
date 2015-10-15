//
//  ScrollViewWidget.h
//  RideScout
//
//  Created by Charlie Cliff on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "RSLabel.h"
#import <RideKit/RKPinPopup.h>

#define SUBTEXT_HEIGHT 30
#define WIDGET_HEADER_HEIGHT 30
#define INDENTATION 10

#define DEFAULT_HEADER_FONT @"OpenSans-Semibold"
#define DEFAULT_HEADER_FONT_SIZE 11

@class RKProfile;

@protocol ProfileWidgetDelegate <NSObject>

- (void)presentViewController:(UIViewController *)viewControllerToPresent;
- (void)dismissViewController:(UIViewController *)viewControllerToPresent;

@end

static BOOL animating;

@interface ProfileWidget : UIView <UITableViewDataSource, UITableViewDelegate> {
    NSInteger currentEditableRow;
}
@property (nonatomic) CGFloat widgetWidth;

@property (nonatomic, weak) id<ProfileWidgetDelegate> delegate;

@property (nonatomic, strong) NSString *headerTitle;

@property (nonatomic, strong) NSArray *cellItems;

@property (nonatomic, strong) RSLabel *headerLabel;
@property (nonatomic, strong) UIImageView *separatorLine;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIScrollView *containterScrollView;

@property (nonatomic, strong) RKPopup *profilePopup;

// Gives option to set the width, the default is SCREEN_WIDTH
- (instancetype)initWithWidth:(CGFloat)width;
- (void)buildView;
- (void)updateViewSize;
- (void)presentPopup:(RKPopup *)popup;
- (void)closePopup:(RKPopup *)popup;

- (void)reload;

@end
