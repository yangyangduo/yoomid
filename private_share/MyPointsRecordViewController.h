//
//  MyPointsRecordViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-20.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "TransitionViewController.h"

@interface MyPointsRecordViewController : TransitionViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>

@end
