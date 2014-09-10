//
//  MerchandiseOrdersViewController.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "PullCollectionView.h"
#import "PanBackTransitionViewController.h"

@interface MerchandiseOrdersViewController : PanBackTransitionViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PullCollectionViewDelegate>

@end
