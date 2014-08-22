//
//  Address.m
//  private_share
//
//  Created by Zhao yang on 6/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Address.h"

@implementation Address

@synthesize latitude;
@synthesize longitude;
@synthesize address;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self && dictionary) {
        self.longitude = [dictionary numberForKey:@"longitude"].doubleValue;
        self.latitude = [dictionary numberForKey:@"latitude"].doubleValue;
        self.address = [dictionary stringForKey:@"address"];   
    }
    return self;
}

@end
