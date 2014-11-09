//
//  PayOrderViewController.h
//  private_share
//
//  Created by 曹大为 on 14/10/14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "WXPayRequest.h"
#import "AliPaymentModal.h"
#import "WeChatSDK_1.4.1/WXApi.h"
#import "BaseViewController.h"

typedef NS_ENUM (NSUInteger, PaymentMode){
    PaymentModeNone,
    PaymentModeWXPay,
    PaymentModeAliPay
};


@interface PayOrderViewController : BaseViewController<WXApiDelegate>

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) PaymentMode paymentMode;
@property (nonatomic, strong) WXPayRequest *wxPayment;
@property (nonatomic, strong) AliPaymentModal *aliPayment;

- (void)setPaymen;
@end
