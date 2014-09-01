//
//  MerchandiseProperty.m
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseProperty.h"

@implementation MerchandiseProperty

@synthesize name;
@synthesize values;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.name = [json noNilStringForKey:@"name"];
        self.values = [json arrayForKey:@"values"];
        if(self.values == nil) {
            self.values = [NSArray array];
        }
    }
    return self;
}

@end
