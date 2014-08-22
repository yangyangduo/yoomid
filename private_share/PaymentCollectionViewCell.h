//
//  PaymentCollectionViewCell.h
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"
#import "NumberPicker.h"
#import "ShoppingCartViewController.h"

@interface PaymentCollectionViewCell : UICollectionViewCell<NumberPickerDelegate>

@property (nonatomic, weak) ShoppingCartViewController *shoppingCartViewController;

- (void)setShoppingItem:(ShoppingItem *)shoppingItem;

@end
