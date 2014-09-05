//
//  UserInfoService.h
//  private_share
//
//  Created by 曹大为 on 14-9-5.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseService.h"

@interface UserInfoService : BaseService


-(void)getUserInfo:(id)target success:(SEL)success failure:(SEL)failure;
-(void)modifyUserInfoData:(NSData*)data target:(id)target success:(SEL)success failure:(SEL)failure;
@end
