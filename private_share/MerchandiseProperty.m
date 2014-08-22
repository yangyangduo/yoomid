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

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self && dictionary) {
        self.name = [dictionary noNilStringForKey:@"name"];
        self.values = [dictionary arrayForKey:@"values"];
        if(self.values == nil) {
            self.values = [NSArray array];
        }
    }
    return self;
}

@end
