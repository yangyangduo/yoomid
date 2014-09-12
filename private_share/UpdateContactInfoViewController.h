//
//  UpdateContactInfoViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-15.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XXStringUtils.h"
#import "ContactService.h"
#import "BackViewController.h"

@interface UpdateContactInfoViewController : BackViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

- (instancetype)initWithContactInfo:(NSMutableArray *)array itmes:(NSInteger)item;


@end
