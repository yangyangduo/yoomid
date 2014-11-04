//
//  MerchandisesOrderHeaderView.h
//  private_share
//
//  Created by 曹大为 on 14/11/4.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItemHeaderView.h"
#import "MerchandiseOrder.h"
#import "CategoryButtonItem.h"

@interface MerchandisesOrderHeaderView : UICollectionReusableView<CategoryButtonItemDelegate>
@property (nonatomic, strong) WXPayRequest *wxPay;
@property (nonatomic, strong) AliPaymentModal *aliPay;
@property (nonatomic, assign) id<deleteOrdersRefreshDelegate> delegate;

- (void)setMerchandiseOrder:(MerchandiseOrder *)merchandiseOrder;
@end
