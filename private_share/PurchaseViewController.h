//
//  PurchaseViewController.h
//  private_share
//
//  Created by Zhao yang on 7/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SettlementView.h"
#import "ContactService.h"
#import "SelectContactAddressViewController.h"
#import "TransitionViewController.h"
#import "YoomidRectModalView.h"

@interface PurchaseViewController : TransitionViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SettlementViewDelegate, selectContactInfoDelegate, UIAlertViewDelegate, ModalViewDelegate>

- (instancetype)initWithShopShoppingItemss:(NSArray *)shopShoppingItemss isFromShoppingCart:(BOOL)isFromShoppingCart;

- (void)refreshSettlementView;

@end
