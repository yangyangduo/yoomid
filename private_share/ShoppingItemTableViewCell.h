//
//  ShoppingItemTableViewCell.h
//  private_share
//
//  Created by Zhao yang on 9/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"

@interface ShoppingItemTableViewCell : UITableViewCell

@property (nonatomic, strong) ShoppingItem *shoppingItem;
@property (nonatomic, weak) id shoppingCartViewController;

+ (CGFloat)calcCellHeightWithShoppingItem:(ShoppingItem *)shoppingItem;

@end
