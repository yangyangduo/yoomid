//
//  SubTaskCategoryView.h
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidBaseModalView.h"

@interface SubTaskCategoryView : YoomidBaseModalView

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (void)addSubviewInScrollView:(UIView *)view;

@end
