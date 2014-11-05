//
//  MerchandiseTemplateTwoViewController.h
//  private_share
//
//  Created by 曹大为 on 14/11/1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//
/*
 *
 *单列大图  小吉推荐模式
 *
 */

#import "TransitionViewController.h"
#import "ColumnView.h"
#import "PullTableView.h"
#import "MerchandiseDetailViewController2.h"

@interface MerchandiseTemplateOneViewController : TransitionViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic, strong) ColumnView *column;

@end
