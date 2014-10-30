//
//  HomePageViewController.h
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "ActiveDisplayScrollView.h"
#import "XiaoJiRecommendView.h"

@interface HomePageViewController : TransitionViewController<ActiveDisplayScrollViewDelegate,XiaoJiRecommendViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end
