//
//  AccountInfoUpdatedEvent.m
//  private_share
//
//  Created by Zhao yang on 6/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AccountInfoUpdatedEvent.h"

@implementation AccountInfoUpdatedEvent


- (id)init {
    self = [super init];
    if(self) {
        self.name = kEventAccountInfoUpdated;
    }
    return self;
}

@end
