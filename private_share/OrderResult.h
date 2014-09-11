//
//  OrderResult.h
//  private_share
//
//  Created by Zhao yang on 9/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface OrderResult : BaseModel

@property (nonatomic, assign) NSInteger pointsPaid;
@property (nonatomic, assign) float cashNeedToPay;

@end
