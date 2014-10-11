//
//  WXPayRequest.m
//  private_share
//
//  Created by 曹大为 on 14/10/11.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "WXPayRequest.h"
#import <ifaddrs.h>
#import <arpa/inet.h>


@implementation WXPayRequest
@synthesize bodys = _bodys;  //
@synthesize input_charset = _input_charset;
@synthesize out_trade_no = _out_trade_no;
@synthesize spbill_create_ip = _spbill_create_ip;
@synthesize total_fee = _total_fee;
@synthesize traceid = _traceid;
@synthesize noncestr = _noncestr;
@synthesize timestamp = _timestamp;

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
//    [json setMayBlankString:self.out_trade_no forKey:@"out_trade_no"];
    [json setObject:self.out_trade_no forKey:@"out_trade_no"];
    [json setMayBlankString:self.spbill_create_ip forKey:@"spbill_create_ip"];
    [json setMayBlankString:self.total_fee forKey:@"total_fee"];
//    [json setMayBlankString:self.traceid forKey:@"traceid"];
    [json setObject:self.traceid forKey:@"traceid"];
    [json setMayBlankString:self.noncestr forKey:@"noncestr"];
    [json setMayBlankString:self.timestamp forKey:@"timestamp"];
    return json;
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
 *
 *  获取本机IP地址
 *
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
    return address;}
@end
