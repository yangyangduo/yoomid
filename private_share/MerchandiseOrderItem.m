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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        self.identifier = [dictionary noNilStringForKey:@"id"];
        self.number = [dictionary numberForKey:@"number"].integerValue;
        self.paymentType = [dictionary numberForKey:@"paymentType"].integerValue;
        self.name = [dictionary noNilStringForKey:@"name"];
        if(self.number == 0) {
            self.points = 0.f;
        } else {
            self.points = [dictionary numberForKey:@"totalPoints"].integerValue / self.number;
        }
        self.cash = [dictionary numberForKey:@"totalCash"].floatValue / self.number;
    }
    return self;
}

@end
