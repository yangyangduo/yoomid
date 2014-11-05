//
//  MerchandiseTemplateOneViewController.h
//  private_share
//
//  Created by 曹大为 on 14/11/1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

/*
 *
 *单列小图  全部商品模板
 *
 */

#import "TransitionViewController.h"
#import "PullTableView.h"
#import "MerchandiseDetailViewController2.h"
#import "Merchandise.h"
#import "ColumnView.h"

@interface MerchandiseTemplateTwoViewController : TransitionViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic, strong) ColumnView *column;

@end
