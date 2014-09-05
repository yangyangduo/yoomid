//
//  CashPaymentTypePicker.m
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CashPaymentTypePicker.h"
#import "UIColor+App.h"

@implementation CashPaymentTypePicker

@synthesize delegate;

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 44)];
        titleView.backgroundColor = [UIColor appColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, titleView.bounds.size.width - 30, 40)];
        titleLabel.text = @"选择支付方式";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.textColor = [UIColor appLightBlue];
        [titleView addSubview:titleLabel];
        [self.contentView addSubview:titleView];
    }
    return self;
}

@end
