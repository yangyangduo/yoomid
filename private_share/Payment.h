//
//  Payment.h
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment : NSObject

@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) float cash;
@property (nonatomic, assign) NSUInteger numberOfMerchandises;

+ (Payment *)emptyPayment;

- (instancetype)initWithPoints:(NSInteger)points cash:(float)cash;
- (instancetype)initWithPoints:(NSInteger)points cash:(float)cash numberOfMerchandises:(NSUInteger)numberOfMerchandises;

- (void)addWithPayment:(Payment *)payment;

@end
