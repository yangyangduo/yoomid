//
//  TaskViewController.h
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DrawerMenuViewController.h"
#import "XXEventSubscriptionPublisher.h"

@interface TaskViewController : DrawerMenuViewController<UITableViewDataSource, UITableViewDelegate, XXEventSubscriber>

@end
