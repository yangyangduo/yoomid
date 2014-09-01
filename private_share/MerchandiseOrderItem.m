//
//  MerchandiseOrderItem.m
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseOrderItem.h"

@implementation MerchandiseOrderItem

@synthesize identifier;
@synthesize number;
@synthesize paymentType;
@synthesize points;
@synthesize cash;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.number = [json numberForKey:@"number"].integerValue;
        self.paymentType = [json numberForKey:@"paymentType"].integerValue;
        self.name = [json noNilStringForKey:@"name"];
        if(self.number == 0) {
            self.points = 0.f;
        } else {
            self.points = [json numberForKey:@"totalPoints"].integerValue / self.number;
        }
        self.cash = [json numberForKey:@"totalCash"].floatValue / self.number;
    }
    return self;
}

@end
