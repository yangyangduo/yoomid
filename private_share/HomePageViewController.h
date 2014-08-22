//
//  HomePageViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "PullScrollZoomImagesView.h"
#import "HomePageItemCell.h"
#import "TaskCategoriesService.h"
#import "TransitionViewController.h"

@interface HomePageViewController : TransitionViewController<UIScrollViewDelegate,PullScrollZoomImagesViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
