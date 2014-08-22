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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self && dictionary) {
        self.orderId = [dictionary noNilStringForKey:@"orderId"];
        self.shopId = [dictionary noNilStringForKey:@"shopId"];
        self.totalPoints = [dictionary numberForKey:@"totalPoints"].integerValue;
        self.totalCash = [dictionary numberForKey:@"totalCash"].floatValue;
        self.returnPoints = [dictionary numberForKey:@"returnPoints"].integerValue;
        self.shopName = [dictionary noNilStringForKey:@"shopName"];
        self.orderState = [dictionary numberForKey:@"orderState"].unsignedIntegerValue;
        self.createTime = [dictionary dateWithMillisecondsForKey:@"createTime"];
        NSArray *mls = [dictionary arrayForKey:@"merchandiseLists"];
        NSMutableArray *orders = [NSMutableArray array];
        if(mls != nil) {
            for(int i=0; i<mls.count; i++) {
                NSDictionary *ml = [mls objectAtIndex:i];
                [orders addObject:[[MerchandiseOrderItem alloc] initWithDictionary:ml]];
            }
        }
        self.merchandiseLists = orders;
    }
    return self;
}

@end
