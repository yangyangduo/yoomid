//
//  Shop.m
//  private_share
//
//  Created by 曹大为 on 14/11/5.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "Shop.h"

@implementation Shop

@synthesize shopName;
@synthesize shopId;


- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.shopId = [json noNilStringForKey:@"id"];
        self.shopName = [json noNilStringForKey:@"name"];
    }
    return self;
}

@end
