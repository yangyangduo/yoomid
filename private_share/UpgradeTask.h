//
//  UpgradeTask.h
//  private_share
//
//  Created by 曹大为 on 14/9/18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "Task.h"

@interface UpgradeTask : Task
@property (nonatomic ,strong) NSString *answer;
@property (nonatomic ,strong) NSString *question;
@property (nonatomic ,strong) NSString *questionId;
@property (nonatomic, strong) NSArray *options;

@end
