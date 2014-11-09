//
//  ConsigneeAddViewController.h
//  private_share
//
//  Created by 曹大为 on 14/11/9.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BackViewController.h"

@interface ConsigneeAddViewController : BackViewController
//如果为0,表示当前用户还没有收货地址
@property (nonatomic, assign) NSInteger index;
@end
