//
//  ShoppingItemHeaderView.h
//  private_share
//
//  Created by Zhao yang on 7/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXPayRequest.h"

#import "CategoryButtonItem.h"
#import "CashPaymentTypePicker.h"

@protocol deleteOrdersRefreshDelegate <NSObject>

- (void)deleteOrdersRefresh;

@end

@interface ShoppingItemHeaderView : UICollectionReusableView<CategoryButtonItemDelegate>

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, assign) float total_points;
@property (nonatomic, strong) WXPayRequest *wxPay;

@property (nonatomic, assign) id<deleteOrdersRefreshDelegate> delegate;

- (void)setSelectButtonHidden;
- (void)setOrderId:(NSString *)orderId;

- (void)setMoreButtonShow;
- (void)setMoreButtonHidden;
@end
