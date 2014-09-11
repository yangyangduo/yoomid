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
@property (nonatomic, assign) long experience;
@property (nonatomic, assign) long taskCount;
@property (nonatomic, assign) NSInteger level;

+ (instancetype)currentAccount;

- (void)clear;
- (void)refresh;

@end
