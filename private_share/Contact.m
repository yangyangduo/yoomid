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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self && dictionary) {
        self.identifier = [dictionary noNilStringForKey:@"id"];
        self.name  = [dictionary noNilStringForKey:@"name"];
        self.phoneNumber = [dictionary noNilStringForKey:@"contactPhone"];
        self.address = [dictionary noNilStringForKey:@"deliveryAddress"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [super toDictionary];
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
