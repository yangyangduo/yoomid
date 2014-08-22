//
//  UpdateContactInfoViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-15.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "XXStringUtils.h"
#import "ContactService.h"

@interface UpdateContactInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

- (instancetype)initWithContactItemss:(NSDictionary *)contactItemss;

- (instancetype)initWithContactInfo:(NSMutableArray *)array itmes:(NSInteger)item;


@end
