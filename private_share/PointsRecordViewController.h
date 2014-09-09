//
//  PointsRecordViewController.h
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "PanBackTransitionViewController.h"

@interface PointsRecordViewController : PanBackTransitionViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@end
