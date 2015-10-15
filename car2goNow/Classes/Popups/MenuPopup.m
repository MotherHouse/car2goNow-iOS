//
//  PopupMenu.m
//  RideScout
//
//  Created by Charlie Cliff on 7/22/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "MenuPopup.h"

#import "constantsAndMacros.h"

#define CONTAINER_VIEW_WIDTH 15

#define TEXT_VIEW_HEIGHT 64.0
#define TEXT_VIEW_EDGE_PAD 15

#define CELL_HEIGHT 44.0

@interface MenuPopup() <UITableViewDataSource, UITableViewDelegate> {
    NSString *headerText;
    NSString *subTitleText;
}

@property (nonatomic, strong) UITableView *actionsTableView;

@end

@implementation MenuPopup

@synthesize actionTitles;

#pragma mark - Life Cycle

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if ( self != nil) {
//        
//    }
//    return self;
//}

#pragma mark - Builders 
// marvel.wikia.com/Builders_(Race)

- (void)buildView {
    [super buildView];
    
    // Remove Extraneous Elements
    [self.headerSeparatorImageView removeFromSuperview];
    self.headerSeparatorImageView = nil;

    // Set Up Header Text
//    [self.headerLabel setFontSize:80];
    
    // Set Up SubTitle Text
    self.subTitleLabel = [[RSLabel alloc] initWithFrame:CGRectMake(TEXT_VIEW_EDGE_PAD, POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width - 2*TEXT_VIEW_EDGE_PAD, TEXT_VIEW_HEIGHT)];
    self.subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.subTitleLabel setHidden:NO];
    [self.subTitleLabel setFontSize:14];
    [self.subTitleLabel setTextColor:BCYCLE_DARK_GREY];
    [self.containerView addSubview:self.subTitleLabel];
}

- (void)buildTableView {
    
    [self.actionsTableView removeFromSuperview];
    
    if ( self.subTitleLabel.isHidden ) {
        // Set Up the Table View
        CGFloat tableY = POPUP_DEFAULT_HEADER_HEIGHT;
        self.actionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, self.containerView.frame.size.width, self.actionTitles.count*CELL_HEIGHT)];
        self.actionsTableView.delegate = self;
        self.actionsTableView.dataSource = self;
        self.actionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.actionsTableView setBackgroundColor:[UIColor clearColor]];
        [self.containerView addSubview:self.actionsTableView];
        
        // Resize the ContainerView
        CGFloat totalHeight = POPUP_DEFAULT_HEADER_HEIGHT + self.actionsTableView.frame.size.height;
        [self.containerView setFrame:CGRectMake(self.containerView.frame.origin.x, (self.frame.size.height-totalHeight)/2, self.containerView.frame.size.width, totalHeight)];
    }
    else {
        // Set Up the Table View
        CGFloat tableY = POPUP_DEFAULT_HEADER_HEIGHT + TEXT_VIEW_HEIGHT;
        self.actionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, self.containerView.frame.size.width, self.actionTitles.count*CELL_HEIGHT)];
        self.actionsTableView.delegate = self;
        self.actionsTableView.dataSource = self;
        self.actionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.actionsTableView setBackgroundColor:[UIColor clearColor]];
        [self.containerView addSubview:self.actionsTableView];
        
        // Resize the ContainerView
        CGFloat totalHeight = POPUP_DEFAULT_HEADER_HEIGHT + TEXT_VIEW_HEIGHT + self.actionsTableView.frame.size.height;
        [self.containerView setFrame:CGRectMake(self.containerView.frame.origin.x, (self.frame.size.height-totalHeight)/2, self.containerView.frame.size.width, totalHeight)];
    }
    
}

- (void)buildActionLabels {
    _actionLabels = [[NSMutableArray alloc] init];
    for (NSString *actionLabelTitle in self.actionTitles) {
        RSLabel *menuItemTitleLabel = [[RSLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        menuItemTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [menuItemTitleLabel setFontSize:17];
        [menuItemTitleLabel setTextColor:BCYCLE_LIGHT_PURPLE];
        [menuItemTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [menuItemTitleLabel setBackgroundColor:[UIColor clearColor]];
        [menuItemTitleLabel setUserInteractionEnabled:YES];
        [menuItemTitleLabel setText:actionLabelTitle];
        [self.actionLabels addObject:menuItemTitleLabel];
    }
}

#pragma mark - Setters

- (void)setActionTitles:(NSArray *)inputActionTitles {
    actionTitles = inputActionTitles;
    [self buildActionLabels];
    [self buildTableView];
}

- (void)setSubTitleHidden:(BOOL)subTitleIsHidden {
    [self.subTitleLabel setHidden:subTitleIsHidden];
    [self.subTitleLabel removeFromSuperview];

    if ( !self.subTitleLabel.isHidden ) {
        [self.containerView addSubview:self.subTitleLabel];
    }
    
    [self buildTableView];
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    
    RSLabel *menuItemTitleLabel = [self.actionLabels objectAtIndex:indexPath.row];
    [menuItemTitleLabel setFrame:cell.contentView.frame];
    [cell.contentView addSubview:menuItemTitleLabel];
    
    // Separator Line
    if (self.shouldDisplayActionItemSeparators) {
        UIImageView *separatorLine = [[UIImageView alloc] init];
        [separatorLine setFrame:CGRectMake(0, 1, self.frame.size.width - 40, POPUP_DEFAULT_SEPEARATOR_WIDTH)];
        [separatorLine setBackgroundColor:COOPER_GRAY];
        [cell.contentView addSubview:separatorLine];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.callback)
        self.callback(self, indexPath.row);
}


@end
