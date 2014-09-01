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

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.longitude = [json numberForKey:@"longitude"].doubleValue;
        self.latitude = [json numberForKey:@"latitude"].doubleValue;
        self.address = [json stringForKey:@"address"];
    }
    return self;
}

@end
