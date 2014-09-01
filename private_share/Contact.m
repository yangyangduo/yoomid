//
//  Contact.m
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize name;
@synthesize phoneNumber;
@synthesize address;
@synthesize identifier;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.name  = [json noNilStringForKey:@"name"];
        self.phoneNumber = [json noNilStringForKey:@"contactPhone"];
        self.address = [json noNilStringForKey:@"deliveryAddress"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *dic = [super toJson];
    /*
    [dic setMayBlankString:self.name forKey:@"name"];
    [dic setMayBlankString:self.phoneNumber forKey:@"contactPhone"];
    [dic setMayBlankString:self.address forKey:@"deliveryAddress"];
     */
    return dic;
}

- (BOOL)isEmpty {
    return self.identifier == nil;
}

@end
