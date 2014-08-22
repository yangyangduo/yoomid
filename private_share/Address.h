//
//  Address.h
//  private_share
//
//  Created by Zhao yang on 6/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface Address : BaseModel

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) NSString *address;

@end
