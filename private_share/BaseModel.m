//
//  BaseModel.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    return [NSMutableDictionary dictionary];
}

@end
