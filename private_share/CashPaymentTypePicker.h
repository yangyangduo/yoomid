//
//  CashPaymentTypePicker.h
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidBaseModalView.h"
#import "ShoppingCart.h"

@protocol CashPaymentTypePickerDelegate;

@interface CashPaymentTypePicker : YoomidBaseModalView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id<CashPaymentTypePickerDelegate> delegate;

@end

@protocol CashPaymentTypePickerDelegate <NSObject>

- (void)cashPaymentTypePicker:(CashPaymentTypePicker *)cashPaymentTypePicker didSelectCashPaymentType:(CashPaymentType)cashPaymentType;

@end
