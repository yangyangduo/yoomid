//
//  TaskListViewController.h
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "TaskCategory.h"
#import "PullCollectionView.h"

@interface TaskListViewController : TransitionViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TaskCategory *taskCategory;

- (instancetype)initWithTaskCategory:(TaskCategory *)taskCategory;

@end
