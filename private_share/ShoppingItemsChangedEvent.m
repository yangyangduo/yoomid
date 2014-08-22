//
//  ShoppingItemsChangedEvent.m
//  private_share
//
//  Created by Zhao yang on 6/21/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemsChangedEvent.h"

@implementation ShoppingItemsChangedEvent

@synthesize totalPayment;

- (id)init {
    self = [super init];
    if(self) {
        self.name = kEventShoppingItemsChanged;
    }
    return self;
}

@end
