//
//  ShoppingItemHeaderView.h
//  private_share
//
//  Created by Zhao yang on 7/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingItemHeaderView : UICollectionReusableView

@property (nonatomic, strong) NSString *shopId;

- (void)setSelectButtonHidden;
- (void)setOrderId:(NSString *)orderId;

- (void)setMoreButtonShow;
- (void)setMoreButtonHidden;
@end
