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

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
//        self.orderId = [dictionary noNilStringForKey:@"orderId"];
        self.points = [json numberForKey:@"points"].integerValue;
        self.taskName = [json noNilStringForKey:@"taskName"];
        self.providerName = [json noNilStringForKey:@"providerName"];
        self.orderType = [json numberForKey:@"orderType"].integerValue;
        self.createTime = [json dateWithMillisecondsForKey:@"timestamp"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    return json;
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
