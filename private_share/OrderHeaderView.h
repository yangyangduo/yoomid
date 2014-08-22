//
//  OrderHeaderView.h
//  private_share
//
//  Created by Zhao yang on 6/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHeaderView : UICollectionReusableView

- (void)setOrderId:(NSString *)orderId orderTime:(NSDate *)orderTime;

@end
