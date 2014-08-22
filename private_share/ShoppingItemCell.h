//
//  ShoppingItemCell.h
//  private_share
//
//  Created by Zhao yang on 7/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"
#import "NumberPicker.h"

@interface ShoppingItemCell : UICollectionViewCell<NumberPickerDelegate>

@property (nonatomic, strong) ShoppingItem *shoppingItem;
@property (nonatomic, weak) id shoppingCartViewController;

+ (CGFloat)calcCellHeightWithShoppingItem:(ShoppingItem *)shoppingItem;

- (void)refreshShoppingItemSelectProperty;

@end
