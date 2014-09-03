//
//  TaskItemCell.h
//  private_share
//
//  Created by Zhao yang on 9/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) Task *task;

@end
