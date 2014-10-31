//
//  RowView.h
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseModel.h"
#import "ColumnView.h"

@interface RowView : BaseModel

//@property (nonatomic, assign) NSInteger orderId;    //
@property (nonatomic, strong) NSArray *columnViews;  //每一行的元素

@property (nonatomic, assign) NSInteger sizes ;         //每一行有多少个

@property (nonatomic, strong) NSString *name;           //名称
@end
