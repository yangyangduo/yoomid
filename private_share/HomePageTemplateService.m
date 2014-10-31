//
//  HomePageTemplateService.m
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "HomePageTemplateService.h"

@implementation HomePageTemplateService

- (void)getHomePageTemlateTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/template/homepage?%@", self.authenticationString] target:target success:success failure:failure userInfo:nil];
}
@end
