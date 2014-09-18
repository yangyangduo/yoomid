//
//  TaskLevelService.h
//  private_share
//
//  Created by 曹大为 on 14/9/17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseService.h"

@interface TaskLevelService : BaseService

-(void)getTasksLevelInfo:(NSInteger)level target:(id)target success:(SEL)success failure:(SEL)failure;

@end
