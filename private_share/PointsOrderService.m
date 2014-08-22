//
//  PointsOrderService.m
//  private_share
//
//  Created by Zhao yang on 6/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PointsOrderService.h"

@implementation PointsOrderService

- (void)getPointsOrdersByPageIndex:(NSInteger)pageIndex orderType:(PointsOrderType)orderType target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self.httpClient get:[NSString stringWithFormat:@"/points_orders?page=%ld&ordertype=%lu&%@", (long)pageIndex, (long)orderType, self.authenticationString] target:target success:success failure:failure userInfo:userInfo];
}

@end
