//
//  ShoppingItemHeaderView.m
//  private_share
//
//  Created by Zhao yang on 7/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemHeaderView.h"
#import "ShoppingCart.h"

@implementation ShoppingItemHeaderView {
    UIButton *selectButton;
    UILabel *titleLabel;
    UILabel *label;
    BOOL hideSelectButton;
}

@synthesize shopId = _shopId_;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40.f, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [self addSubview:lineView];
        
        self.backgroundColor = [UIColor whiteColor];
        selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateNormal];
//        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateHighlighted];
        [selectButton setImage:[UIImage imageNamed:@"cb_select"] forState:UIControlStateSelected];
        [self addSubview:selectButton];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"shop", @"")];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        label.hidden = YES;
        [self addSubview:label];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectButton.bounds.size.width, 0, 200, 44)];
        titleLabel.text = @"";
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setSelectButtonHidden {
    hideSelectButton = YES;
    selectButton.hidden = YES;
    label.hidden = NO;
}

- (void)setShopId:(NSString *)shopId {
    _shopId_ = shopId;
    titleLabel.text = @"有米得商城";
    if(!hideSelectButton) {
        selectButton.selected = [[ShoppingCart myShoppingCart] selectWithShopId:_shopId_];
    }
}

- (void)selectButtonPressed:(id)sender {
    [[ShoppingCart myShoppingCart] setSelect:!selectButton.selected forShopId:self.shopId];
}

@end
