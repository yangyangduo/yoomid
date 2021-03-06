//
//  WXPayRequest.h
//  private_share
//
//  Created by 曹大为 on 14/10/11.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseModel.h"
#import "CommonUtil.h"
#import "WeChatSDK_1.4.1/WXApi.h"

/*
 *
 *  向服务器申请，获取access_token, package,预支付的app_signature
 *
 */
@interface WXPayRequest : BaseModel
@property (nonatomic ,strong) NSString *wxAppId;

@property (nonatomic ,strong) NSString *bodys;
@property (nonatomic ,strong) NSString *input_charset;
@property (nonatomic ,strong) NSString *out_trade_no;
@property (nonatomic ,strong) NSString *spbill_create_ip;
@property (nonatomic ,strong) NSString *total_fee;
@property (nonatomic ,strong) NSString *traceid;
@property (nonatomic ,strong) NSString *noncestr;
@property (nonatomic ,strong) NSString *timestamp;

@property (nonatomic ,strong) NSString *access_token;
@property (nonatomic ,strong) NSString *app_signature;
@property (nonatomic ,strong) NSString *package_content;

@property (nonatomic ,strong) NSString *prepayid;
@property (nonatomic ,strong) NSString *sign;

@property (nonatomic ,strong) NSString *mallName;
@property (nonatomic ,strong) NSString *merchandiseName;
- (void) setAccess_tokens:(NSDictionary *)access_tokens;

- (void) payCash;
@end
