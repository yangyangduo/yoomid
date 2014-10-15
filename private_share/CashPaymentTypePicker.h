//
//  CashPaymentTypePicker.h
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidBaseModalView.h"
#import "ShoppingCart.h"
#import "CategoryButtonItem.h"

@interface CashPaymentTypePicker : YoomidBaseModalView<CategoryButtonItemDelegate>

@property (nonatomic, assign) id<CategoryButtonItemDelegate> btnItemDelegate;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (instancetype)initWithSize:(CGSize)size message:(NSString *)message buttonItems:(NSArray *)buttonItems;
@end

