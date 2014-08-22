//
//  TaskCategoriesService.h
//  private_share
//
//  Created by 曹大为 on 14-8-21.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseService.h"

@interface TaskCategoriesService : BaseService

-(void)getCategories:(id)target success:(SEL)success failure:(SEL)failure;

@end
