//
//  NameValue.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NameValue.h"

@implementation NameValue

@synthesize identifier = _identifier_;
@synthesize name = _name_;
@synthesize value = _value_;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name value:(NSString *)value {
    self = [super init];
    if(self) {
        _identifier_ = identifier;
        _name_ = name;
        _value_ = value;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name value:(id)value {
    self = [super init];
    if(self) {
        _name_ = name;
        _value_ = value;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if(object == nil) return NO;
    if([object isKindOfClass:[NameValue class]]) {
        NameValue *their = (NameValue *)object;
        if(their.name == nil) return NO;
        return [their.name isEqualToString:self.name];
    }
    return NO;
}

@end
