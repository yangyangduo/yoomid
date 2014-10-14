//
//  AliPaymentModal.h
//  private_share
//
//  Created by 曹大为 on 14/10/14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface AliPaymentModal : BaseModel

@property (nonatomic, strong) NSString *partner;        //合作身份者id
@property (nonatomic, strong) NSString *out_trade_no;   //订单编号
@property (nonatomic, strong) NSString *subject;        //商家名称
@property (nonatomic, strong) NSString *body;           //商品名字
@property (nonatomic, strong) NSString *total_fee;      //需要支付的现金
@property (nonatomic, strong) NSString *notify_url;     //网址需要做URL编码
@property (nonatomic, strong) NSString *service;        //
@property (nonatomic, strong) NSString *input_charset;  //
//@property (nonatomic, strong) NSString *return_url;
@property (nonatomic, strong) NSString *payment_type;
@property (nonatomic, strong) NSString *seller_id;      //收款支付宝账号
@property (nonatomic, strong) NSString *it_b_pay;       //支付有效期,
//
@property (nonatomic, strong) NSString *sign;
- (NSString *) toStrings;

@end
