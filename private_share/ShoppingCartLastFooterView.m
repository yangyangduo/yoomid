//
//  ShoppingCartLastFooterView.m
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCartLastFooterView.h"

@implementation ShoppingCartLastFooterView {
    UILabel *titleLabel;
    UILabel *cashLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 300, 90)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.numberOfLines = 5;
        NSMutableAttributedString *tipString = [[NSMutableAttributedString alloc] init];
        [tipString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_tips_title", @"") attributes:@{ NSForegroundColorAttributeName : [UIColor appBlue], NSFontAttributeName :  [UIFont systemFontOfSize:14.f] }]];
        [tipString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_tips1", @"") attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor],  NSFontAttributeName :  [UIFont systemFontOfSize:12.f] }]];
        [tipString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_tips2", @"") attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName :  [UIFont systemFontOfSize:12.f]}]];
        tipLabel.attributedText = tipString;
        [self addSubview:tipLabel];
    }
    return self;
}

@end
