//
//  MerchandiseService.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchandiseOrder.h"
#import "ShoppingCart.h"
#import "BaseService.h"

@interface MerchandiseService : BaseService

- (void)submitShoppingCart:(id)target success:(SEL)success failure:(SEL)failure saveContact:(BOOL)saveContact userInfo:(id)userInfo;

- (void)getMerchandisesWithShopId:(NSString *)shopId pageIndex:(NSInteger)pageIndex target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

- (void)getHentreStoreMerchandisesByPageIndex:(NSInteger)pageIndex target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

- (void)getMerchandiseOrdersByPageIndex:(NSInteger)pageIndex orderState:(MerchandiseOrderState)orderState target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

- (void)getActivityMerchandisesWithShopId:(NSString *)shopId pageIndex:(NSInteger)pageIndex target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

- (void)submitActivityWithShopId:(NSString *)shopId activityId:(NSString *)activityId target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

@end
