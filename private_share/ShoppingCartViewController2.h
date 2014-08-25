//
//  ShoppingCartViewController2.h
//  private_share
//
//  Created by Zhao yang on 7/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "DrawerMenuViewController.h"
#import "XXEventSubscriptionPublisher.h"
#import "UIParameterAlertView.h"
#import "SettlementView.h"
#import "TransitionViewController.h"

@interface ShoppingCartViewController2 : TransitionViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XXEventSubscriber, SettlementViewDelegate>

@end
