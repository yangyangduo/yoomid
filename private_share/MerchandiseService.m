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

- (void)submitOrders:(NSData *)orders target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self.httpClient post:[NSString stringWithFormat:@"/merchandise_orders?%@", self.authenticationString] contentType:@"application/json" body:orders target:target success:success failure:failure userInfo:userInfo];
}

- (void)submitOrdersDiyong:(NSString *)diyong body:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient post:[NSString stringWithFormat:@"/merchandise_orders?diyong=%@&%@",diyong,self.authenticationString] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:userInfo];
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

- (void)getMerchandiseOrdersByPageIndex:(NSInteger)pageIndex orderState:(NSInteger)orderState target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self.httpClient get:[NSString stringWithFormat:@"/merchandise_orders?page=%ld&orderState=%lu&%@", (long)pageIndex, (long)orderState, self.authenticationString] target:target success:success failure:failure userInfo:userInfo];
}

- (void)getEcommendedMerchandisesTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"merchandises/recommend?%@", self.authenticationString] target:target success:success failure:failure userInfo:nil];
}

- (void)sendGoodWithMerchandiseId:(NSString *)merchandiseId target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient get:[NSString stringWithFormat:@"/adhoc/like?id=%@&action=true&%@",merchandiseId ,self.authenticationString] target:target success:success failure:failure userInfo:nil];
}
- (void)getGoodWithMerchandiseId:(NSString *)merchandiseId target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient get:[NSString stringWithFormat:@"/adhoc/like?id=%@&action=false&%@",merchandiseId ,self.authenticationString] target:target success:success failure:failure userInfo:nil];
}

- (void)submitPayRequestBody:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient post:[NSString stringWithFormat:@"/wxpay/pay_request?%@", self.authenticationString] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:userInfo];
}

- (void)deleteOrders:(NSString *)orders target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient put:[NSString stringWithFormat:@"/orders_cancel/%@?%@",orders,self.authenticationString] contentType:@"application/json" body:nil target:target success:success failure:failure userInfo:nil];
}

- (void)submitWXPaySign:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient post:[NSString stringWithFormat:@"/wxpay/pay_sign_request?%@",self.authenticationString] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:nil];
}

- (void)submitAliPaySign:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient post:[NSString stringWithFormat:@"/tbpay/pay_sign_request?%@",self.authenticationString] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:nil];
}

- (void)getShopInfoTarget:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo
{
    [self.httpClient get:[NSString stringWithFormat:@"/shop/all_app?%@",self.authenticationString] target:target success:success failure:failure userInfo:userInfo];
}
@end
