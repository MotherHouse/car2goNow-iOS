//
//  ReceiptViewController.h
//  RideScout
//
//  Created by Charlie Cliff on 8/19/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Receipt;

@interface ReceiptViewController : UIViewController

@property (nonatomic, strong) void (^closeBlock)(ReceiptViewController *receiptVC);

- (instancetype)initWithReceipt:(Receipt *)receipt;
- (void)setReceipt:(Receipt *)reeipt;

@end
