//
//  AnswerOptions.m
//  private_share
//
//  Created by 曹大为 on 14/9/18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AnswerOptions.h"

@implementation AnswerOptions
@synthesize description;
@synthesize option;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
    }
    return  self;
}
@end
