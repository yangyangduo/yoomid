//
//  TaskDetailViewController.h
//  private_share
//
//  Created by Zhao yang on 8/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionViewController.h"

@interface TaskDetailViewController : TransitionViewController<UIWebViewDelegate>

- (instancetype)initWithTaskDetailUrl:(NSString *)url;

@end
