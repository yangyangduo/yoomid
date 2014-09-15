//
//  ShoppingItemTableHeaderView.h
//  private_share
//
//  Created by Zhao yang on 9/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingItemTableHeaderView : UIView

@property (nonatomic, strong) NSString *shopId;

- (void)setSelectButtonHidden;
- (void)setOrderId:(NSString *)orderId;

@end
