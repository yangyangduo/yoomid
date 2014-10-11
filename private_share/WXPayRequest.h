//
//  WXPayRequest.h
//  private_share
//
//  Created by 曹大为 on 14/10/11.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseModel.h"

/*
 *
 *  向服务器申请，获取access_token, package,预支付的app_signature
 *
 */
@interface WXPayRequest : BaseModel

@property (nonatomic ,strong) NSString *bodys;
@property (nonatomic ,strong) NSString *input_charset;
@property (nonatomic ,strong) NSString *out_trade_no;
@property (nonatomic ,strong) NSString *spbill_create_ip;
@property (nonatomic ,strong) NSString *total_fee;
@property (nonatomic ,strong) NSString *traceid;
@property (nonatomic ,strong) NSString *noncestr;
@property (nonatomic ,strong) NSString *timestamp;

@end
