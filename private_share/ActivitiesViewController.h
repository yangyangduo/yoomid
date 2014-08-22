//
//  ActivitiesViewController.h
//  private_share
//
//  Created by Zhao yang on 6/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerMenuViewController.h"
#import "PullCollectionView.h"

@interface ActivitiesViewController : DrawerMenuViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PullCollectionViewDelegate>

@end
