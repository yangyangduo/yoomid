//
//  Consignee.h
//  private_share
//
//  Created by 曹大为 on 14/11/7.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

/*
 *
 *  收货人信息
 *
 */

#import "BaseModel.h"

@interface Consignee : BaseModel
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *isDefault;

- (BOOL)isEmpty;

@end
