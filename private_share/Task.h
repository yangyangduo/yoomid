//
//  Task.h
//  private_share
//
//  Created by Zhao yang on 9/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface Task : BaseModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, assign) NSInteger *requiredUserLebel;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger timeLimitInSeconds;
@property (nonatomic, strong) NSString *imageUrl;
//@property (nonatomic, strong) NSDate *deadLine;

@end
