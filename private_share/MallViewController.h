//
//  MallViewController.h
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "DrawerMenuViewController.h"
#import "PullTableView.h"
#import "TransitionViewController.h"

@interface MallViewController : TransitionViewController<
    UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, UINavigationControllerDelegate>

@end
