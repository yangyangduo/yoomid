//
//  ReturnMessage.m
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ReturnMessage.h"

@implementation ReturnMessage

@synthesize messageKey;
@synthesize message;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.messageKey = [json noNilStringForKey:@"messageKey"];
        self.message  = [json noNilStringForKey:@"message"];
    }
    return self;
}

@end
