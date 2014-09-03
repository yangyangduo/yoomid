//
//  SelectContactAddressViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "PanBackTransitionViewController.h"
#import "SelectContactAddressTableViewCell.h"


@protocol selectContactInfoDelegate <NSObject>

-(void)contactInfo:(Contact*)contact selectd:(NSInteger)select;

@end

@interface SelectContactAddressViewController : PanBackTransitionViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)id<selectContactInfoDelegate>delegate;

-(instancetype)initWithContactInfo:(NSMutableArray*)contactArrays selected:(NSInteger)select;
@end
