//
//  PointsOrder.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PointsOrder.h"

@implementation PointsOrder

@synthesize points;
@synthesize createTime;
@synthesize orderType;
@synthesize taskName;
@synthesize providerName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self && dictionary) {
//        self.orderId = [dictionary noNilStringForKey:@"orderId"];
        self.points = [dictionary numberForKey:@"points"].integerValue;
        self.taskName = [dictionary noNilStringForKey:@"taskName"];
        self.providerName = [dictionary noNilStringForKey:@"providerName"];
        self.orderType = [dictionary numberForKey:@"orderType"].integerValue;
        self.createTime = [dictionary dateWithMillisecondsForKey:@"timestamp"];
    }
    return self;
}

+ (NSString *)pointsOrderTypeAsString:(PointsOrderType)pointsOrderType {
    if(PointsOrderTypeIncome == pointsOrderType) {
        return @"收入";
    } else if(PointsOrderTypePay == pointsOrderType) {
        return @"支出";
    }
    return @"";
}

@end
