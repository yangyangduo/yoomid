//
//  ActivitiesService.m
//  private_share
//
//  Created by 曹大为 on 14-9-12.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ActivitiesService.h"

@implementation ActivitiesService

-(void)getActivitiesInfo:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/activities?shopId=0000&%@", self.authenticationString] target:target success:success failure:failure userInfo:nil];
}
@end
