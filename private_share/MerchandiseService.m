//
//  MerchandiseService.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseService.h"

@implementation MerchandiseService

- (void)submitShoppingCart:(id)target success:(SEL)success failure:(SEL)failure saveContact:(BOOL)saveContact userInfo:(id)userInfo {
    NSData *body = [JsonUtil createJsonDataFromDictionary:[[ShoppingCart myShoppingCart] toDictionaryWithShopID:kHentreStoreID]];
    [self.httpClient post:[NSString stringWithFormat:@"/merchandise_orders?saveContact=%@&%@", (saveContact ? @"true" : @"false"), self.authenticationString] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:userInfo];
}

- (void)submitActivityWithShopId:(NSString *)shopId activityId:(NSString *)activityId target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    NSDictionary *dictionary = @{
                                 @"shopId" : shopId,
                                 @"merchandiseLists" : @[ @{ @"id" : activityId } ]
                           };
    NSData *body = [JsonUtil createJsonDataFromDictionary:dictionary];
    [self.httpClient post:[NSString stringWithFormat:@"/activity_merchandise_orders"] contentType:@"application/json" body:body target:self success:success failure:failure userInfo:userInfo];
}

- (void)getMerchandisesWithShopId:(NSString *)shopId pageIndex:(NSInteger)pageIndex target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self.httpClient get:[NSString stringWithFormat:@"/merchandises?page=%ld&shopId=%@&%@", (long)pageIndex, shopId, self.authenticationString] target:target success:success failure:failure userInfo:userInfo];
}

- (void)getActivityMerchandisesWithShopId:(NSString *)shopId pageIndex:(NSInteger)pageIndex target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self.httpClient get:[NSString stringWithFormat:@"/merchandises?page=%ld&shopId=%@&%@&merchandiseType=activity", (long)pageIndex, shopId, self.authenticationString] target:target success:success failure:failure userInfo:userInfo];
}

- (void)getHentreStoreMerchandisesByPageIndex:(NSInteger)pageIndex target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self getMerchandisesWithShopId:kHentreStoreID pageIndex:pageIndex target:target success:success failure:failure userInfo:userInfo];
}

- (void)getMerchandiseOrdersByPageIndex:(NSInteger)pageIndex orderState:(MerchandiseOrderState)orderState target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self.httpClient get:[NSString stringWithFormat:@"/merchandise_orders?page=%ld&orderState=%lu&%@", (long)pageIndex, (long)orderState, self.authenticationString] target:target success:success failure:failure userInfo:userInfo];
}

@end
