
//
//  ReceiptsWidget.m
//  RideScout
//
//  Created by Charlie Cliff on 8/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ReceiptsWidget.h"

#import "Receipt.h"
#import "ProfileCellData.h"
#import "ProfileWidgetCell.h"

#import "TripManager.h"

#import "ReceiptViewController.h"

#import "constantsAndMacros.h"
#import "messageCopy.h"

@interface ReceiptsWidget ()

@property (nonatomic, strong) NSArray *sectionHeaders;
@property (nonatomic, strong) NSDictionary *receiptGroups;
@property (nonatomic, strong) NSMutableArray *receipts;


@end

@implementation ReceiptsWidget

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self!=nil) {
        _numberOfReceiptsShown = DEFAULT_NUMBER_OF_RECEIPTS_TO_FETCH - 1;
        self.headerTitle = RECEIPT_WIDGET_TITLE;
        [self iterateNumberOfReceiptsShown];
    }
    return self;
}

- (instancetype)initWithWidth:(CGFloat)width {
    self = [super initWithWidth:width];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Build

- (void)buildView {
    [super buildView];
    [self buildMoreTripsView];
    [self updateViewSize];
}

- (void)buildMoreTripsView {
    if ([self.moreView superview] != nil) {
        [self.moreView removeFromSuperview];
    }
    
    self.moreView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.frame.size.width, SUBTEXT_HEIGHT)];
    [self.moreView setBackgroundColor:RIDESCOUT_WHITE];
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake((self.moreView.frame.size.width - 100)/2, 0, 100, self.moreView.frame.size.height)];
    [self.moreButton addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton.titleLabel setFont:[UIFont fontWithName:DEFAULT_HEADER_FONT size:DEFAULT_TITLE_FONT_SIZE]];
    [self.moreButton setTitle:@"MORE" forState:UIControlStateNormal];
    [self.moreButton setTitleColor:BCYCLE_BLUE forState:UIControlStateNormal];
    if ([self.moreView superview] == nil) {
        [self.moreView addSubview:self.moreButton];
    }
    
    UIImageView *separatorLine = [[UIImageView alloc] init];
    separatorLine.backgroundColor = [UIColor colorWithWhite:1 alpha:.2];
    [separatorLine setFrame:CGRectMake(10, 0, self.frame.size.width-10, 1)];
    if ([self.separatorLine superview] == nil) {
        [self.moreView addSubview:self.separatorLine];
    }
    
    if ( (self.receipts.count > self.numberOfReceiptsShown)) {
        [self addSubview:self.moreView];
    }
}

- (void)updateViewSize {
    CGRect frame = self.tableView.frame;
    [self.tableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.cellItems.count*PROFILE_WIDGET_CELL_HEIGHT)];
    if (self.receipts.count == 0) {
        [self setHidden:YES];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0)];
    }
    else if ( (self.receipts.count > self.numberOfReceiptsShown)) {
        [self setHidden:NO];
        [self.moreView setFrame: CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.frame.size.width, SUBTEXT_HEIGHT)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.tableView.frame.origin.y + self.tableView.frame.size.height + SUBTEXT_HEIGHT)];
    }
    else {
        [self setHidden:NO];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.tableView.frame.origin.y + self.tableView.frame.size.height)];
    }
}

#pragma mark - Actions

- (void)moreButtonPressed {
    self.numberOfReceiptsShown = self.numberOfReceiptsShown + 3;
    [self iterateNumberOfReceiptsShown];
}

- (void)iterateNumberOfReceiptsShown {
    if ( [[TripManager sharedTripManager].receipts count] <= self.numberOfReceiptsShown ) {
        [[TripManager sharedTripManager] getMostRecentReceipts:[NSNumber numberWithInteger:(self.numberOfReceiptsShown + 1)] ];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:TRIP_NOTIFICATION_RECEIPTS_DID_UPDATE object:nil userInfo:nil];
    }
}

#pragma mark - Refresh

- (void)reload {
    NSInteger totalReceiptCount = [[TripManager sharedTripManager].receipts count];
    NSRange range = NSMakeRange(0, MIN(totalReceiptCount, self.numberOfReceiptsShown+1) );
    self.receipts = [[[TripManager sharedTripManager].receipts subarrayWithRange:range] copy];
    [self setUpCellData];
    [self.tableView reloadData];    
    [self buildMoreTripsView];
    [self updateViewSize];
}

#pragma mark - ProfileCellData

- (void)setUpCellData {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i < MIN(self.numberOfReceiptsShown, self.receipts.count); i++) {
        Receipt *receipt = [self.receipts objectAtIndex:i];
        ProfileCellData *receiptCellData = [self convertReceiptToCellData:receipt];
        [data addObject:receiptCellData];
    }
    self.cellItems = [NSArray arrayWithArray:data];
}

#pragma mark - Helpers

- (ProfileCellData *)convertReceiptToCellData:(Receipt *)receipt {
    // Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd, yyyy";
    ProfileCellData *data = [[ProfileCellData alloc] init];
    data.titleString = [receipt getProviderName];
    data.subTitleString = [dateFormatter stringFromDate:receipt.transactionDate];
    data.detailString = [NSString stringWithFormat:@"$%.2f",[receipt.userCost floatValue]];
    data.cellActionable = YES;
    data.titleActionable = YES;
    data.subTitleActionable = NO;
    data.detailActionable = NO;
    return data;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileWidgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileWidgetCell"];
    if (!cell) {
        cell = [[ProfileWidgetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileWidgetCell"];
    }
    
    cell.showSeparator = YES;
    cell.cellData = [self.cellItems objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.leftUtilityButtons = nil;
    cell.rightUtilityButtons = nil;
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Receipt *selectedReceipt = [self.receipts objectAtIndex:row];
    ReceiptViewController *vc = [[ReceiptViewController alloc] init];
    [vc setReceipt:selectedReceipt];
    __block __weak __typeof(self)blockSelf = self;
    [vc setCloseBlock:^(ReceiptViewController *vc) {
        [blockSelf.delegate dismissViewController:vc];
    }];
    [self.delegate presentViewController:vc];
}

#pragma mark - Actions

- (void)presentReceiptViewControllerForReceipt:(Receipt *)receipt {
    ReceiptViewController *vc = [[ReceiptViewController alloc] init];
    [vc setReceipt:receipt];
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ( [viewController isKindOfClass:[UINavigationController class]] ) {
        [((UINavigationController *)viewController) pushViewController:vc animated:YES];
    }
    else {
        [viewController presentViewController:vc animated:YES completion:nil];
    }
}

@end
