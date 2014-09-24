//
//  UserInfoService.m
//  private_share
//
//  Created by 曹大为 on 14-9-5.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UserInfoService.h"
#import "Account.h"
#import "UIDevice+Identifier.h"
//NSString *str = [Account currentAccount].accountId;

@implementation UserInfoService

-(void)getUserInfo:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/profile/view/%@?%@",[Account currentAccount].accountId,self.authenticationString] target:target success:success failure:failure userInfo:nil];
}

-(void)modifyUserInfoData:(NSData *)data target:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient put:[NSString stringWithFormat:@"/profile/upt?%@",self.authenticationString] contentType:@"application/json" body:data target:target success:success failure:false userInfo:nil];
}

-(void)getSettingPointsTarget:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/yoomid/points_order/internal/settings?device=%@&%@",[UIDevice idfaString],self.authenticationString] target:target success:success failure:failure userInfo:nil];

}
@end
