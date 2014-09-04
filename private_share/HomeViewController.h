//
//  HomePageViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "AdPlatformPickerView.h"
#import "CategoryButtonItem.h"
#import "ImagesScrollView.h"

@interface HomeViewController : TransitionViewController<UIScrollViewDelegate, UICollectionViewDelegate, ImagesScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CategoryButtonItemDelegate, ModalViewDelegate>

@property (nonatomic, strong) NSMutableArray *allCategories;
@property (nonatomic, strong) NSMutableArray *rootCategories;

@end
