//
//  SelectContactAddressViewController.h
//  private_share
//
//  Created by 曹大为 on 14-8-13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//
@protocol selectContactInfoDelegate <NSObject>

-(void)contactInfo:(NSDictionary*)dictionary_contact fag:(NSInteger)fags;

@end

#import "BaseViewController.h"
#import "PanBackTransitionViewController.h"

@interface SelectContactAddressViewController : PanBackTransitionViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)id<selectContactInfoDelegate>delegate;

-(instancetype)initWithContactInfo:(NSMutableArray*)contactArrays fag:(NSInteger)fag;
@end
