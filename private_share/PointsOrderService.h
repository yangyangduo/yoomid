//
//  PointsOrderService.h
//  private_share
//
//  Created by Zhao yang on 6/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseService.h"
#import "MerchandiseService.h"
#import "PointsOrder.h"

@interface PointsOrderService : BaseService

- (void)getPointsOrdersByPageIndex:(NSInteger)pageIndex orderType:(PointsOrderType)orderType target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

@end
