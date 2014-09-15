//
//  ShoppingItemTableFooterView.h
//  private_share
//
//  Created by Zhao yang on 9/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"
#import "ShopShoppingItems.h"

@interface RemarkTextField : UITextField

@property (nonatomic, strong) ShopShoppingItems *shopShoppingItems;

@end

@interface ShoppingItemTableFooterView : UIView

@property (nonatomic, strong) ShopShoppingItems *shopShoppingItems;
@property (nonatomic, weak) id purchaseViewController;

@end
