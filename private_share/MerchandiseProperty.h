//
//  MerchandiseProperty.h
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface MerchandiseProperty : BaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *values;

@end
