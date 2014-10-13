//
//  WXPayRequest.m
//  private_share
//
//  Created by 曹大为 on 14/10/11.
//  Copyright (c) 2014年 hentre. All rights reserved.
//
#import "YoomidRectModalView.h"
#import "ReturnMessage.h"
#import "WXPayRequest.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "XXAlertView.h"
#import "MerchandiseService.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation WXPayRequest
@synthesize wxAppId = _wxAppId;

@synthesize bodys = _bodys;  //
@synthesize input_charset = _input_charset;
@synthesize out_trade_no = _out_trade_no;
@synthesize spbill_create_ip = _spbill_create_ip;
@synthesize total_fee = _total_fee;
@synthesize traceid = _traceid;
@synthesize noncestr = _noncestr;
@synthesize timestamp = _timestamp;

@synthesize access_token = _access_token;
@synthesize app_signature = _app_signature;
@synthesize package_content = _package_content;

@synthesize prepayid = _prepayid;
@synthesize sign = _sign;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wxAppId = @"wxb3bc53583590b23f";
        self.input_charset = @"UTF-8";
        self.spbill_create_ip = [self getIPAddress];
//        double curTime = [self getCurrentDate];
//        
//        self.noncestr = [NSString stringWithFormat:@"%.0f",curTime];
//        self.timestamp = [NSString stringWithFormat:@"%.0f",curTime/1000];
        self.noncestr = [self genNonceStr];
        self.timestamp = [self genTimeStamp];
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.bodys = [json noNilStringForKey:@"body"];
        self.input_charset = @"UTF-8";
        self.out_trade_no = [json noNilStringForKey:@"out_trade_no"];
        self.spbill_create_ip = [self getIPAddress];
        self.total_fee = [json noNilStringForKey:@"total_fee"];
        self.traceid = [json noNilStringForKey:@"out_trade_no"];
        double curTime = [self getCurrentDate];
        
        self.noncestr = [NSString stringWithFormat:@"%.0f",curTime];
        self.timestamp = [NSString stringWithFormat:@"%.0f",curTime/1000];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.bodys forKey:@"body"];
    [json setMayBlankString:self.input_charset forKey:@"input_charset"];
    [json setMayBlankString:self.out_trade_no forKey:@"out_trade_no"];
    [json setMayBlankString:self.spbill_create_ip forKey:@"spbill_create_ip"];
    [json setMayBlankString:self.total_fee forKey:@"total_fee"];
    [json setMayBlankString:self.traceid forKey:@"traceid"];
    [json setMayBlankString:self.noncestr forKey:@"noncestr"];
    [json setMayBlankString:self.timestamp forKey:@"timestamp"];
    return json;
}

- (void)setAccess_tokens:(NSDictionary *)access_tokens
{
    self.access_token = [access_tokens noNilStringForKey:@"access_token"];
    self.app_signature = [access_tokens noNilStringForKey:@"app_signature"];
    self.package_content = [access_tokens noNilStringForKey:@"package_content"];
}

- (double) getCurrentDate
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyyMMddHHmmss"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
//    NSLog(@"%@",curTime);
    return curTime.doubleValue;
}

/*
 *  获取本机IP地址
 */
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (void)submitFailure:(HttpResponse *)resp {
    NSString *errorMessage = @"出错啦!";
    if(1001 == resp.statusCode) {
        errorMessage = @"请求超时!";
    } else if(400 == resp.statusCode) {
        if(resp.contentType != nil && resp.body != nil && [resp.contentType rangeOfString:@"application/json" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSDictionary *_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
            if(_json_ != nil) {
                ReturnMessage *message = [[ReturnMessage alloc] initWithJson:_json_];
                errorMessage = [NSString stringWithFormat:@"对不起,%@!", message.message];
            }
        }
    } else if(403 == resp.statusCode) {
        errorMessage = @"请重新登录后再尝试!";
    } else {
        errorMessage = @"出错啦!";
    }
    [[XXAlertView currentAlertView] dismissAlertViewCompletion:^{
        YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 340) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cry@2x" ofType:@"png"]] message:errorMessage buttonTitles:@[ @"支付失败" ] cancelButtonIndex:0];
        [[UIApplication sharedApplication].delegate window];
        [modal showInView:[UIApplication sharedApplication].keyWindow completion:nil];
    }];
}

- (void)payCash
{
    NSMutableDictionary *tempD = [[NSMutableDictionary alloc] initWithDictionary:[self toJson]];
    [[XXAlertView currentAlertView] setMessage:@"正在打开微信支付..." forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    MerchandiseService *service = [[MerchandiseService alloc] init];
    [service submitPayRequestBody:[JsonUtil createJsonDataFromDictionary:tempD] target:self success:@selector(submitPayRequestSuccess:) failure:@selector(submitFailure:) userInfo:nil];
}

- (void)submitPayRequestSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
        NSDictionary *access_token_json = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if (access_token_json != nil) {
            [self setAccess_tokens:access_token_json];
        }
        
        NSMutableDictionary *paramsD = [NSMutableDictionary dictionary];
        [paramsD setObject:self.wxAppId forKey:@"appid"];
        [paramsD setObject:self.noncestr forKey:@"noncestr"];
        [paramsD setObject:self.timestamp forKey:@"timestamp"];
        [paramsD setObject:self.traceid forKey:@"traceid"];
        [paramsD setObject:self.package_content forKey:@"package"];
        [paramsD setObject:self.app_signature forKey:@"app_signature"];
        [paramsD setObject:@"sha1" forKey:@"sign_method"];
//        NSLog(@"%@",paramsD);
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsD options:NSJSONWritingPrettyPrinted error: &error];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@",self.access_token];
        
        NSMutableURLRequest *mrequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        
        //设置提交方式
        [mrequest setHTTPMethod:@"POST"];
        //设置数据类型
        [mrequest addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        //设置编码
        [mrequest setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
        
        [mrequest setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mrequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *prepayid_json = [JsonUtil createDictionaryOrArrayFromJsonData:responseObject];
            long errCode = [[prepayid_json objectForKey:@"errcode"] longValue];
            if (errCode == 0) {
                NSLog(@"JSON: %@", prepayid_json);
                self.prepayid = [prepayid_json objectForKey:@"prepayid"];
                NSLog(@"prepay ID:%@",self.prepayid);
                
                NSDictionary *paySignDict = @{@"prepayid": self.prepayid,
                                              @"package": @"Sign=WXPay",
                                              @"noncestr": self.noncestr,
                                              @"timestamp": self.timestamp};
                
                MerchandiseService *service = [[MerchandiseService alloc] init];
                [service submitWXPaySign:[JsonUtil createJsonDataFromDictionary:paySignDict] target:self success:@selector(submitWXPaySignSuccess:) failure:@selector(submitFailure:) userInfo:nil];
            }else{
                [[XXAlertView currentAlertView] setMessage:@"打开微信支付失败!" forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[XXAlertView currentAlertView] setMessage:@"打开微信支付错误!" forType:AlertViewTypeFailed];
            [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        
        return;
    }
    [self submitFailure:resp];
}

- (void)submitWXPaySignSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 201) {
        [[XXAlertView currentAlertView] dismissAlertView];
        NSDictionary *sign_json = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSLog(@"JSON: %@", sign_json);
        
        self.sign = [sign_json objectForKey:@"sign"];
        
        PayReq *payRequest = [[PayReq alloc] init];
        payRequest.partnerId = @"1220874801";
        payRequest.prepayId = self.prepayid;
        payRequest.package = @"Sign=WXPay";
        payRequest.nonceStr = self.noncestr;
        payRequest.timeStamp = (UInt32)[self.timestamp longLongValue];
        payRequest.sign = self.sign;
        
        [WXApi safeSendReq:payRequest];
        return;
    }
    [self submitFailure:resp];
}


@end
