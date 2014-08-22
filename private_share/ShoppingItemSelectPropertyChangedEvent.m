//
//  ShoppingItemSelectPropertyChangedEvent.m
//  private_share
//
//  Created by Zhao yang on 7/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemSelectPropertyChangedEvent.h"

@implementation ShoppingItemSelectPropertyChangedEvent

- (id)init {
    self = [super init];
    if(self) {
        self.name = kEventShoppingItemSelectPropertyChangedEvent;
    }
    return self;
}

@end