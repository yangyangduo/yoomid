//
//  BaseModel.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self && dictionary) {
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    return [NSMutableDictionary dictionary];
}

@end
