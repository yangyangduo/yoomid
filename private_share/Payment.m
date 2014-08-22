//
//  Payment.m
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Payment.h"

@implementation Payment

@synthesize points = _points_;
@synthesize cash = _cash_;
@synthesize numberOfMerchandises = _numberOfMerchandises;

+ (Payment *)emptyPayment {
    return [[Payment alloc] initWithPoints:0 cash:0.f numberOfMerchandises:0];
}

- (instancetype)initWithPoints:(NSInteger)points cash:(float)cash {
    self = [super init];
    if(self) {
        _points_ = points;
        _cash_ = cash;
        _numberOfMerchandises = 1;
    }
    return self;
}

- (instancetype)initWithPoints:(NSInteger)points cash:(float)cash numberOfMerchandises:(NSUInteger)numberOfMerchandises {
    self = [super init];
    if(self) {
        _points_ = points;
        _cash_ = cash;
        _numberOfMerchandises = numberOfMerchandises;
    }
    return self;
}

- (void)addWithPayment:(Payment *)payment {
    if(payment == nil) return;
    self.points += payment.points;
    self.cash += payment.cash;
    self.numberOfMerchandises += payment.numberOfMerchandises;
}

- (id)copy {
    Payment *newPayment = [[Payment alloc] init];
    newPayment.points = self.points;
    newPayment.cash = self.cash;
    newPayment.numberOfMerchandises = self.numberOfMerchandises;
    return newPayment;
}

@end
