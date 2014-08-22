//
//  ShoppingCartViewController.h
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIParameterAlertView.h"
#import "XXEventSubscriptionPublisher.h"

@interface ShoppingCartViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate, XXEventSubscriber>

@end
