//
//  OrderItemCell.h
//  private_share
//
//  Created by Zhao yang on 6/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemCell : UICollectionViewCell

- (void)setTitle:(NSString *)title number:(NSInteger)number points:(NSInteger)points;
- (void)setTitle:(NSString *)title number:(NSInteger)number cash:(float)cash;

@end
