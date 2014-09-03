//
//  TaskCategoriesService.m
//  private_share
//
//  Created by 曹大为 on 14-8-21.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TaskCategoriesService.h"

@implementation TaskCategoriesService

-(void)getCategories:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/platform/yoomid/categories?%@", self.authenticationString] target:target success:success failure:failure userInfo:nil];
}
@end
