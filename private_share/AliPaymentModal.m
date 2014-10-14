//
//  AliPaymentModal.m
//  private_share
//
//  Created by 曹大为 on 14/10/14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AliPaymentModal.h"

@implementation AliPaymentModal
@synthesize partner = _partner;
@synthesize out_trade_no = _out_trade_no;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize total_fee = _total_fee;
@synthesize notify_url = _notify_url;
@synthesize service = _service;
@synthesize input_charset = _input_charset;
@synthesize payment_type = _payment_type;
@synthesize seller_id = _seller_id;
@synthesize it_b_pay = _it_b_pay;
@synthesize sign = _sign;

- (instancetype)init//Hentre201212
{
    self = [super init];
    if (self) {
        self.partner =  @"2088611117775840";
        self.notify_url =  @"http://www.yoomid.com/moneymoney/tbpay/payNotify";
        self.service = @"mobile.securitypay.pay";
        self.input_charset = @"UTF-8";
        self.payment_type = @"1";
        self.seller_id =  @"payment@yoomid.com";
        self.it_b_pay = @"3d";
    }
    return self;
}

- (NSString *)toStrings{
    NSMutableString * paySign = [NSMutableString string];
    [paySign appendFormat:@"partner=\"%@\"", self.partner ? self.partner : @""];
	[paySign appendFormat:@"&seller_id=\"%@\"", self.seller_id ? self.seller_id : @""];
	[paySign appendFormat:@"&out_trade_no=\"%@\"", self.out_trade_no ? self.out_trade_no : @""];
	[paySign appendFormat:@"&subject=\"%@\"", self.subject ? self.subject : @""];
	[paySign appendFormat:@"&body=\"%@\"", self.body ? self.body : @""];
	[paySign appendFormat:@"&total_fee=\"%@\"", self.total_fee ? self.total_fee : @""];
	[paySign appendFormat:@"&notify_url=\"%@\"", self.notify_url ? self.notify_url : @""];
    
    [paySign appendFormat:@"&service=\"%@\"", self.service ? self.service : @"mobile.securitypay.pay"];
	[paySign appendFormat:@"&_input_charset=\"%@\"", self.input_charset ? self.input_charset : @"utf-8"];
    [paySign appendFormat:@"&payment_type=\"%@\"", self.payment_type ? self.payment_type : @"1"];
    [paySign appendFormat:@"&it_b_pay=\"%@\"", self.it_b_pay ? self.it_b_pay : @"1d"];
    
    return paySign;
}

@end
