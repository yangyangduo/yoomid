//
//  MerchandiseOrder.h
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, MerchandiseOrderState) {
    MerchandiseOrderStateUnCashPayment    = 1,
    MerchandiseOrderStateSubmitted        = 2,
    MerchandiseOrderStateUnConfirmed      = 4,
    MerchandiseOrderStateConfirmed        = 8
};

@interface MerchandiseOrder : BaseModel

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) NSInteger returnPoints;
@property (nonatomic, assign) float totalCash;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, assign) MerchandiseOrderState orderState;
@property (nonatomic, strong) NSMutableArray *merchandiseLists;

@property (nonatomic, strong) NSString *loginame;
@property (nonatomic, strong) NSString *sendno;
@end
