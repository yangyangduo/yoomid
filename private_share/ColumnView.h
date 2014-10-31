//
//  ColumnView.h
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface ColumnView : BaseModel

@property (nonatomic ,strong) NSString *imgUrl;	// 图片路径

@property (nonatomic ,assign) NSInteger types;  //类别 1为活动,2为店铺

@property (nonatomic ,assign) NSInteger viewType;//视图类别 1,2,3,4

@property (nonatomic ,strong) NSString *cid;    //如果type为1 此字段为活动ID,type为2此字段为店铺ID

@property (nonatomic ,strong) NSString *names;  //店铺名称或者活动名称

@end
