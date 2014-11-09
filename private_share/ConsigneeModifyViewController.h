//
//  ConsigneeModifyViewController.h
//  private_share
//
//  Created by 曹大为 on 14/11/7.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BackViewController.h"
#import "Consignee.h"

@interface ConsigneeModifyViewController : BackViewController
//<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

- (instancetype)initWithConsignee:(Consignee *)consignee;
@end
