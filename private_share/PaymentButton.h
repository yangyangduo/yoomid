//
//  PaymentButton.h
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"

@interface PaymentButton : UIButton

- (instancetype)initWithPoint:(CGPoint)point paymentType:(PaymentType)paymentType points:(NSInteger)points returnPoints:(NSInteger)returnPoints;

@end
