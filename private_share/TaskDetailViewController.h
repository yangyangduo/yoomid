//
//  TaskDetailViewController.h
//  private_share
//
//  Created by Zhao yang on 8/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanBackTransitionViewController.h"
#import "Task.h"

@interface TaskDetailViewController : PanBackTransitionViewController<UIWebViewDelegate>

- (instancetype)initWithTask:(Task *)task;

@property (nonatomic, strong) Task *task;

@end
