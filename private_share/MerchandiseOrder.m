//
//  MerchandiseOrder.m
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseOrder.h"

@implementation MerchandiseOrder

@synthesize orderId;
@synthesize shopId;
@synthesize shopName;
@synthesize totalPoints;
@synthesize returnPoints;
@synthesize totalCash;
@synthesize createTime;
@synthesize orderState;
@synthesize merchandiseLists;

@synthesize loginame;
@synthesize sendno;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.orderId = [json noNilStringForKey:@"orderId"];
        self.shopId = [json noNilStringForKey:@"shopId"];
        self.totalPoints = [json numberForKey:@"totalPoints"].integerValue;
        self.totalCash = [json numberForKey:@"totalCash"].floatValue;
        self.returnPoints = [json numberForKey:@"returnPoints"].integerValue;
        self.shopName = [json noNilStringForKey:@"shopName"];
        self.orderState = [json numberForKey:@"orderState"].unsignedIntegerValue;
        self.createTime = [json dateWithMillisecondsForKey:@"createTime"];
        
        self.loginame = [json noNilStringForKey:@"loginame"];
        self.sendno = [json noNilStringForKey:@"sendno"];
        
        self.merchandiseLists = [NSMutableArray array];
    }
    return self;
}

@end
