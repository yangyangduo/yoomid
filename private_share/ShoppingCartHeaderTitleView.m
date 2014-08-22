//
//  ShoppingCartHeaderTitleView.m
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCartHeaderTitleView.h"

@implementation ShoppingCartHeaderTitleView {
    UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 14.5f, 15, 15)];
    imageView.image = [UIImage imageNamed:@"icon_shopping_cart"];
    [self addSubview:imageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 180, 24)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"";
    [self addSubview:titleLabel];
}

- (void)prepareForReuse {
}

- (void)setTitle:(NSString *)title {
    if(titleLabel && title)
        titleLabel.text = title;
}

@end
