//
//  PaymentInfoCell.h
//  RideScout
//
//  Created by Brady Miller on 2/9/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentInfoCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *creditCardView;
@property (nonatomic, strong) IBOutlet UIImageView *creditCardImageView;
@property (nonatomic, strong) IBOutlet UILabel *maskedCreditCardNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *defaultCreditCardLabel;

@property (nonatomic, strong) IBOutlet UIView *drawerView;
@property (nonatomic, strong) IBOutlet UIButton *deleteCardButton;
@property (nonatomic, strong) IBOutlet UIButton *makeDefaultCardButton;

@property (nonatomic, strong) IBOutlet UIView *addMethodCellView;

@end
