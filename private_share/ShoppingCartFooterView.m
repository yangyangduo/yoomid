//
//  ShoppingCartFooterView.m
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCartFooterView.h"

@implementation ShoppingCartFooterView {
    UILabel *titleLabel;
    UILabel *contentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, self.bounds.size.width, 0.5f)];
        lineView.backgroundColor = [UIColor appTextFieldGray];
        [self addSubview:lineView];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 30)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:13.f];
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.text = @"";
        [self addSubview:contentLabel];
    }
    return self;
}

- (void)setPoints:(NSInteger)points {
    if(contentLabel) {
        contentLabel.text = [NSString stringWithFormat:@"%@: %ld %@", NSLocalizedString(@"points_exchange_total", @""), (long)points, NSLocalizedString(@"points", @"")];
    }
}

- (void)setCash:(float)cash {
    if(contentLabel) {
        contentLabel.text = [NSString stringWithFormat:@"%@: %.1f%@", NSLocalizedString(@"cash_exchange_total", @""), cash, NSLocalizedString(@"yuan", @"")];
    }
}

@end
