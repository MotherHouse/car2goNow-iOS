//
//  RideOptionCell.m
//  RideScout
//
//  Created by Jason Dimitriou on 6/5/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RideOptionCell.h"

@implementation RideOptionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Setters

- (void)setProvider:(Provider *)provider {
    _provider = provider;
}

@end
