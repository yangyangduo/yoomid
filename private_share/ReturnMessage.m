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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self && dictionary) {
        self.messageKey = [dictionary noNilStringForKey:@"messageKey"];
        self.message  = [dictionary noNilStringForKey:@"message"];
    }
    return self;
}

@end
