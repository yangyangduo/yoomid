//
//  ShoppingItemFooterView.h
//  private_share
//
//  Created by Zhao yang on 7/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"

@interface ShoppingItemFooterView : UICollectionReusableView

- (void)setTotalPayment:(Payment *)payment;

@end
