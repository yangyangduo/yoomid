//
//  ActivitiesService.h
//  private_share
//
//  Created by 曹大为 on 14-9-12.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseService.h"

@interface ActivitiesService : BaseService
-(void)getActivitiesInfo:(id)target success:(SEL)success failure:(SEL)failure;

@end
