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
        NSArray *mls = [json arrayForKey:@"merchandiseLists"];
        NSMutableArray *orders = [NSMutableArray array];
        if(mls != nil) {
            for(int i=0; i<mls.count; i++) {
                NSDictionary *ml = [mls objectAtIndex:i];
                [orders addObject:[[MerchandiseOrderItem alloc] initWithJson:ml]];
            }
        }
        self.merchandiseLists = orders;
    }
    return self;
}

@end
