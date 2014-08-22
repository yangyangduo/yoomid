//
//  PurchaseViewController.h
//  private_share
//
//  Created by Zhao yang on 7/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "SettlementView.h"
#import "ContactService.h"
#import "SelectContactAddressViewController.h"

@interface PurchaseViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SettlementViewDelegate, selectContactInfoDelegate,UIAlertViewDelegate>

- (instancetype)initWithShopShoppingItemss:(NSArray *)shopShoppingItemss;

@end
