//
//  Account.h
//  private_share
//
//  Created by Zhao yang on 6/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Account : BaseModel

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, assign) NSInteger points;

+ (instancetype)currentAccount;
- (void)clear;

- (void)refreshPoints;

@end
