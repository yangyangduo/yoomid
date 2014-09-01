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
@synthesize isDefault;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.name  = [json noNilStringForKey:@"name"];
        self.phoneNumber = [json noNilStringForKey:@"contactPhone"];
        self.address = [json noNilStringForKey:@"deliveryAddress"];
        self.isDefault = [json booleanForKey:@"default"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.identifier forKey:@"id"];
    [json setMayBlankString:self.name forKey:@"name"];
    [json setMayBlankString:self.phoneNumber forKey:@"contactPhone"];
    [json setMayBlankString:self.address forKey:@"deliveryAddress"];
    [json setBoolean:self.isDefault forKey:@"default"];
    return json;
}

- (id)copy {
    Contact *newContact = [[Contact alloc] init];
    newContact.identifier = self.identifier;
    newContact.phoneNumber = self.phoneNumber;
    newContact.address = self.address;
    newContact.isDefault = self.isDefault;
    newContact.name = self.name;
    return newContact;
}

- (BOOL)isEmpty {
    return self.identifier == nil;
}

@end
