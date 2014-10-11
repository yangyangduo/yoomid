//
//  OrderResult.m
//  private_share
//
//  Created by Zhao yang on 9/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "OrderResult.h"

@implementation OrderResult

@synthesize pointsPaid;
@synthesize cashNeedToPay;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.pointsPaid = [json numberForKey:@"pointsPaid"].integerValue;
        self.cashNeedToPay = [json numberForKey:@"cashNeedToPay"].floatValue;
        NSArray *array = [json objectForKey:@"orderIds"];
        self.orderIds = [array objectAtIndex:0];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setInteger:self.pointsPaid forKey:@"pointsPaid"];
    [json setNoNilObject:[NSNumber numberWithFloat:self.cashNeedToPay] forKey:@"cashNeedToPay"];
    [json setNoNilObject:self.orderIds forKey:@"orderIds"];
    return json;
}

@end
