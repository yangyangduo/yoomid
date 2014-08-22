//
//  MerchandiseOrder.h
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"
#import "MerchandiseOrderItem.h"

typedef NS_ENUM(NSUInteger, MerchandiseOrderState) {
    MerchandiseOrderStateSubmitted     = 1,
    MerchandiseOrderStateTransaction   = 2,
    MerchandiseOrderStateCancelled     = 3
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

@end
