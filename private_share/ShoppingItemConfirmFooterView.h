//
//  ShoppingItemConfirmFooterView.h
//  private_share
//
//  Created by Zhao yang on 9/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"
#import "ShopShoppingItems.h"

@interface ShoppingItemConfirmFooterView : UICollectionReusableView<UITextViewDelegate>

@property (nonatomic, strong) ShopShoppingItems *shopShoppingItems;

@end
