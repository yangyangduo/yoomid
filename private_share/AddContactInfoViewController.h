//
//  AddContactInfoViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactService.h"
#import "PanBackTransitionViewController.h"

@interface AddContactInfoViewController : PanBackTransitionViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

-(instancetype)initWithContactArray:(NSInteger)fag;

@end
