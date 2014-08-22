//
//  PointsOrder.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, PointsOrderType) {
    PointsOrderTypeAdTask           = 1,
    PointsOrderTypeShopping         = 2,
    PointsOrderTypeReturnPoints     = 3
};

@interface PointsOrder : BaseModel

@property (nonatomic, assign) PointsOrderType orderType;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSString *providerName;

+ (NSString *)pointsOrderTypeAsString:(PointsOrderType)pointsOrderType;

@end
