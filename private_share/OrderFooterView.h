//
//  OrderFooterView.h
//  private_share
//
//  Created by Zhao yang on 6/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFooterView : UICollectionReusableView

@property (nonatomic, weak) UIViewController *containerViewController;

- (void)setTotalPoints:(NSInteger)totalPoints totalCash:(float)totalCash orderId:(NSString *)orderId;

@end
