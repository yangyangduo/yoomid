//
//  TaskCategoryService.h
//  private_share
//
//  Created by 曹大为 on 14-8-21.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseService.h"

@interface TaskService : BaseService

-(void)getCategories:(id)target success:(SEL)success failure:(SEL)failure;

- (void)getTasksWithCategoryId:(NSString *)categoryId target:(id)target success:(SEL)success failure:(SEL)failure;

- (void)postAnswers:(NSDictionary *)contentJson target:(id)target success:(SEL)success failure:(SEL)failure taskResult:(NSInteger)taskResult;

@end
