//
//  TaskDetailViewController.h
//  private_share
//
//  Created by Zhao yang on 8/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackViewController.h"
#import "YoomidRectModalView.h"
#import "YoomidSemicircleModalView.h"
#import "Task.h"

@interface TaskDetailViewController : BackViewController<UIWebViewDelegate, ModalViewDelegate,ShareDeletage>

- (instancetype)initWithTask:(Task *)task;

@property (nonatomic, strong) Task *task;

@end
