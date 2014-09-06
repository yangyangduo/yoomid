//
//  OrderShoppingItemCell.h
//  private_share
//
//  Created by Zhao yang on 9/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"

@interface OrderShoppingItemCell : UICollectionViewCell

@property (nonatomic, strong) ShoppingItem *shoppingItem;

+ (CGFloat)calcCellHeightWithShoppingItem:(ShoppingItem *)shoppingItem;

@end
