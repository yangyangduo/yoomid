//
//  PayOrderViewController.h
//  private_share
//
//  Created by 曹大为 on 14/10/14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "WXPayRequest.h"
#import "AliPaymentModal.h"
#import "WeChatSDK_1.4.1/WXApi.h"

typedef NS_ENUM (NSUInteger, PaymentMode){
    PaymentModeNone,
    PaymentModeWXPay,
    PaymentModeAliPay
};


@interface PayOrderViewController : TransitionViewController<WXApiDelegate>

@property (nonatomic, assign) PaymentMode paymentMode;
@property (nonatomic, strong) WXPayRequest *wxPayment;
@property (nonatomic, strong) AliPaymentModal *aliPayment;

- (void)setPaymen;
@end
