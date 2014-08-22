//
//  MerchandiseOrderItem.h
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface MerchandiseOrderItem : BaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, assign) NSUInteger paymentType;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) float cash;

@end
