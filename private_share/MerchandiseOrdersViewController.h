//
//  MerchandiseOrdersViewController.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PullCollectionView.h"
#import "BackViewController.h"
#import "WXPayRequest.h"
#import "ShoppingItemConfirmCell.h"
#import "ShoppingItemHeaderView.h"
#import "ShoppingItemFooterView.h"

@interface MerchandiseOrdersViewController : BackViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PullCollectionViewDelegate, deleteOrdersRefreshDelegate>

@end
