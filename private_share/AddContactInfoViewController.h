//
//  AddContactInfoViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ContactService.h"
#import "BackViewController.h"

@interface AddContactInfoViewController : BackViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

-(instancetype)initWithContactArray:(NSInteger)fag;

@end
