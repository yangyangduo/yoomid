//
//  XiaoJiRecommendTemplateViewController.h
//  private_share
//
//  Created by 曹大为 on 14/11/1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "PullRefreshTableView.h"

@interface XiaoJiRecommendTemplateViewController : TransitionViewController<UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

- (instancetype) initWithIndex:(NSInteger)index Merchandise:(NSMutableArray *)merchandise;

@end
