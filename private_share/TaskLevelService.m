//
//  TaskLevelService.m
//  private_share
//
//  Created by 曹大为 on 14/9/17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TaskLevelService.h"
#import "Account.h"

@implementation TaskLevelService

-(void)getTasksLevelInfo:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/tasks/level?level=%d&%@",0 ,self.authenticationString] target:target success:success failure:failure userInfo:nil];
}
@end
