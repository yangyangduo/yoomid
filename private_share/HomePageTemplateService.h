//
//  HomePageTemplateService.h
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseService.h"

@interface HomePageTemplateService : BaseService

- (void)getHomePageTemlateTarget:(id)target success:(SEL)success failure:(SEL)failure;
@end
