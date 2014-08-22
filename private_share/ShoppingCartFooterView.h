//
//  ShoppingCartFooterView.h
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCart.h"
#import "UIColor+App.h"

@interface ShoppingCartFooterView : UICollectionReusableView

- (void)setCash:(float)cash;
- (void)setPoints:(NSInteger)points;

@end
