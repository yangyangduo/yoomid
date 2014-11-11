//
//  AddContactInfoViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ContactService.h"
#import "BackViewController.h"

@protocol AddContactInfoDelegate <NSObject>

- (void)addContactSuccess;

@end

@interface AddContactInfoViewController : BackViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

-(instancetype)initWithContactArray:(NSInteger)fag;
@property (nonatomic, assign) id<AddContactInfoDelegate> addDelegate;

@end
