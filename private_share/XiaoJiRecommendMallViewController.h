//
//  XiaoJiRecommendMallViewController.h
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "PullTableView.h"
#import "MerchandiseDetailViewController2.h"
#import "Merchandise.h"
#import "ColumnView.h"

@interface XiaoJiRecommendMallViewController : TransitionViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic ,strong) NSMutableArray *recommendedMerchandises;
//- (instancetype) initWithXiaoJiRecommend:(NSMutableArray *)recommendedMerchandises;
@property (nonatomic, strong) ColumnView *column;

@end
