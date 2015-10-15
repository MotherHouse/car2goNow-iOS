//
//  RSActionSheet.h
//  RideScout
//
//  Created by Jason Dimitriou on 6/24/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)

@class RSActionSheet;

typedef void (^RSActionCallback)(RSActionSheet *actionSheet, NSInteger buttonIndex);

@protocol RSActionSheetDelegate <NSObject>

-(void)actionSheet:(RSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface RSActionSheet : UIView

- (id)initWithTitle:(NSString *)title delegate:(id<RSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitlesArray:(NSArray *)otherTitlesArray;
- (id)initWithTitle:(NSString *)title callback:(RSActionCallback)callback cancelButtonTitle:(NSString *)cancelTitle otherButtonTitlesArray:(NSArray *)otherTitlesArray;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withHorizontalOffset:(CGFloat)xOffset;
- (void)removeFromView;

@property (weak) id <RSActionSheetDelegate> delegate;
@property NSMutableArray *buttons;
@property (nonatomic) NSString *title;
@property (nonatomic, copy) RSActionCallback callback;
@property BOOL visible, hasCancelButton;

@end
