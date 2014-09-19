//
//  YoomidRectModalView1.h
//  private_share
//
//  Created by 曹大为 on 14/9/20.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "YoomidRectModalView.h"
#import "TaskListViewController.h"

@interface YoomidRectModalView1 : YoomidRectModalView
- (instancetype)initWithSize:(CGSize)size image:(UIImage *)image message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex;
@property (nonatomic,strong) TaskListViewController *taskListVC;

@end
