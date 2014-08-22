//
//  SettlementView.h
//  private_share
//
//  Created by Zhao yang on 7/21/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"

@protocol SettlementViewDelegate;

@interface SettlementView : UIView

@property (nonatomic, weak) id<SettlementViewDelegate> delegate;

- (void)setPayment:(Payment *)payment;
- (void)setSelectButtonHidden;

@end

@protocol SettlementViewDelegate<NSObject>

- (void)purchaseButtonPressed:(id)sender;

@end
