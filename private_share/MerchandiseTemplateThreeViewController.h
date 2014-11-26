//
//  MerchandiseTemplateThreeViewController.h
//  private_share
//
//  Created by 曹大为 on 14/11/17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "PullCollectionView.h"
#import "ColumnView.h"

@interface MerchandiseTemplateThreeViewController : TransitionViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PullCollectionViewDelegate>

@property (nonatomic, strong) ColumnView *column;

@end
