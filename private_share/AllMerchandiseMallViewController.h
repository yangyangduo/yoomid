//
//  AllMerchandiseMallViewController.h
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "ColumnView.h"
#import "PullTableView.h"

@interface AllMerchandiseMallViewController : TransitionViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic, strong) ColumnView *column;

@end
