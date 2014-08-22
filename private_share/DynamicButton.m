//
//  DynamicButton.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DynamicButton.h"

@implementation DynamicButton

@synthesize nameValue = _nameValue_;

- (instancetype)initWithFrame:(CGRect)frame nameValue:(NameValue *)nameValue {
    self = [super initWithFrame:frame];
    if(self) {
        _nameValue_ = nameValue;
        [self setTitle:_nameValue_.name forState:UIControlStateNormal];
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = 4;
    }
    return self;
}

@end
