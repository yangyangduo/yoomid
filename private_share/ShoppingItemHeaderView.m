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
    BOOL hideSelectButton;
    
    UIButton *moreButton;
}

@synthesize shopId = _shopId_;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 44, frame.size.width, 44)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [backgroundView addSubview:lineView];
        
        selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateNormal];
//        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateHighlighted];
        [selectButton setImage:[UIImage imageNamed:@"cb_select"] forState:UIControlStateSelected];
        [backgroundView addSubview:selectButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectButton.bounds.size.width, 0, 260, 44)];
        titleLabel.text = @"";
        titleLabel.font = [UIFont systemFontOfSize:17.f];
        [backgroundView addSubview:titleLabel];
        
        moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 40, 10, 23, 23)];
        [moreButton addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        moreButton.hidden = YES;
        [backgroundView addSubview:moreButton];
    }
    return self;
}

- (void)setSelectButtonHidden {
    hideSelectButton = YES;
    selectButton.hidden = YES;
    CGRect tFrame = titleLabel.frame;
    tFrame.origin.x = 10;
    titleLabel.frame = tFrame;
}

- (void)setOrderId:(NSString *)orderId {
    titleLabel.text = [NSString stringWithFormat:@"单号: %@", orderId];
}

- (void)setShopId:(NSString *)shopId {
    _shopId_ = shopId;
    titleLabel.text = @"小吉商城";
    if(!hideSelectButton) {
        selectButton.selected = [[ShoppingCart myShoppingCart] selectWithShopId:_shopId_];
    }
}

- (void)selectButtonPressed:(id)sender {
    [[ShoppingCart myShoppingCart] setSelect:!selectButton.selected forShopId:self.shopId];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setMoreButtonShow
{
    moreButton.hidden = NO;
}

- (void)setMoreButtonHidden
{
    moreButton.hidden = YES;
}

- (void)moreButtonPressed:(id)sender {
}
@end
