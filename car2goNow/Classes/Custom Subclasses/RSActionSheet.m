//
//  RSActionSheet.m
//  RideScout
//
//  Created by Jason Dimitriou on 6/24/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RSActionSheet.h"
#import "constantsAndMacros.h"
#import "RSLabel.h"

#define ACTION_SHEET_ROW_HEIGHT 44.0
#define ACTION_SHEET_VERTICAL_MARGIN 20.0
#define ACTION_SHEET_HORIZONTAL_MARGIN 0.0
#define ACTION_SHEET_CORNER_RADIUS 0.0

#define DEFAULT_VIEW_WIDTH (self.frame.size.width - 2*ACTION_SHEET_HORIZONTAL_MARGIN)

@interface RSActionSheet () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat additionalWidth;
    CGFloat bottomMargin;

}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *actionsTableView;
@property (nonatomic, strong) NSArray *actionTitles;
@property (nonatomic, strong) RSLabel *titleLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation RSActionSheet

#pragma mark - inits

- (id)init {
    self = [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    if (self!=nil) {
        CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
        bottomMargin = rect.size.height - 20;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title delegate:(id<RSActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitlesArray:(NSArray *)otherTitlesArray {
    self = [self init];
    self.delegate = delegate;
    
    NSMutableArray *titles = [otherTitlesArray mutableCopy];
    
    // set up cancel button
    if (cancelTitle) {
        [titles addObject:cancelTitle];
        self.hasCancelButton = true;
    }
    
    self.actionTitles = [NSArray arrayWithArray:titles];
    
    self.title = title;
    
    [self buildView];
    return self;
}

- (id)initWithTitle:(NSString *)title callback:(RSActionCallback)callback cancelButtonTitle:(NSString *)cancelTitle otherButtonTitlesArray:(NSArray *)otherTitlesArray {
    self = [self init];
    self.callback = callback;
    
    NSMutableArray *titles = [otherTitlesArray mutableCopy];
    
    // set up cancel button
    if (cancelTitle) {
        [titles addObject:cancelTitle];
        self.hasCancelButton = true;
    }
    
    self.actionTitles = [NSArray arrayWithArray:titles];
    
    self.title = title;
    
    [self buildView];
    return self;
}

- (void)buildView {
    [self setBackgroundColor:[UIColor clearColor]];
    
    // Title
    if (self.title) {
        self.titleLabel = [[RSLabel alloc] init];
        [self.titleLabel setFrame:CGRectMake(0, 0, DEFAULT_VIEW_WIDTH, ACTION_SHEET_ROW_HEIGHT)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:BCYCLE_DARK_GREY];
        self.titleLabel.text = self.title;
        [self.titleLabel setFontSize:17];
    }
    
    // Action Table
    CGFloat tableY = self.titleLabel.frame.size.height;
    self.actionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, DEFAULT_VIEW_WIDTH, self.actionTitles.count*ACTION_SHEET_ROW_HEIGHT)];
    [self.actionsTableView setBackgroundColor:[UIColor clearColor]];
    self.actionsTableView.delegate = self;
    self.actionsTableView.dataSource = self;
    self.actionsTableView.scrollEnabled = NO;
    self.actionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Container View
    CGFloat containerHeight = self.actionsTableView.frame.size.height + bottomMargin + self.titleLabel.frame.size.height;
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, DEFAULT_VIEW_WIDTH, containerHeight)];
    [self.containerView setBackgroundColor:RIDESCOUT_WHITE];
    [self.containerView.layer setCornerRadius:ACTION_SHEET_CORNER_RADIUS];

    [self addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.actionsTableView];
    
    // Background View
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.backgroundImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    self.backgroundImageView.userInteractionEnabled = NO;
    self.backgroundImageView.alpha = 0;
    [self addSubview:self.backgroundImageView];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ACTION_SHEET_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.text = [self.actionTitles objectAtIndex:indexPath.row];
    
    if (self.hasCancelButton && indexPath.row == self.actionTitles.count - 1) {
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:15.0];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    }
    cell.textLabel.textColor = BCYCLE_LIGHT_PURPLE;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row != self.actionTitles.count - 1) {
        UIImageView *separatorLine = [[UIImageView alloc] init];
        separatorLine.backgroundColor = COOPER_GRAY;
        [separatorLine setFrame:CGRectMake(20, cell.bounds.size.height-1, self.frame.size.width + additionalWidth - 40, STANDARD_LINE_WEIGHT)];
        [cell.contentView addSubview:separatorLine];
    }
    
    cell.backgroundColor = RIDESCOUT_WHITE;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate) [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    if(self.callback) self.callback(self, indexPath.row);
    [self removeFromView];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.15f
                     animations:^() {
                         cell.textLabel.alpha = .80f;
                     }];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.3f
                     animations:^() {
                         cell.textLabel.alpha = 1.0f;
                     }];
}


#pragma mark - Actions

- (void)showInView:(UIView *)view {
    [self showInView:view withHorizontalOffset:0];
}

- (void)showInView:(UIView *)view withHorizontalOffset:(CGFloat)xOffset {
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ([viewController presentedViewController]) viewController = [viewController presentedViewController];
    UIView *vcView = viewController.view;
    CGRect sscreenFrame = CGRectMake(0, 0, vcView.frame.size.width,  vcView.frame.size.height);
    
    
    CGRect theScreenRect = [UIScreen mainScreen].bounds;
    
    float x = SCREEN_WIDTH / 2.0;
    float height;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        height = CGRectGetHeight(theScreenRect);
    } else {
        height = CGRectGetWidth(theScreenRect);
    }
    
    self.containerView.center = CGPointMake(x, height + CGRectGetHeight(self.containerView.frame) / 2.0);
    [self.backgroundImageView setFrame:sscreenFrame];
    self.backgroundImageView.alpha = 1;
    
    [self sendSubviewToBack:self.backgroundImageView];
    [self setFrame:sscreenFrame];
    
    [vcView addSubview:self];
    [UIView animateWithDuration:0.3f
                          delay:0
         usingSpringWithDamping:0.85f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGFloat centerPointY = height - CGRectGetHeight(self.containerView.frame) / 2.0;
                         self.containerView.center = CGPointMake(x, centerPointY);
                         self.backgroundImageView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         self.visible = YES;
                     }];
}


- (void)removeFromView {
    [UIView animateWithDuration:0.3f
                          delay:0
         usingSpringWithDamping:0.85f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.containerView.center = CGPointMake( (CGRectGetWidth(self.containerView.frame) + self->additionalWidth) / 2.0, CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetHeight(self.containerView.frame) / 2.0);
                         self.backgroundImageView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         self.visible = NO;
                     }];
}


@end
