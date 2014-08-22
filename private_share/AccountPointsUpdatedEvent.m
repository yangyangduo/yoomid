//
//  AccountPointsUpdatedEvent.m
//  private_share
//
//  Created by Zhao yang on 6/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AccountPointsUpdatedEvent.h"

@implementation AccountPointsUpdatedEvent

@synthesize newPoints;

- (id)init {
    self = [super init];
    if(self) {
        self.name = kEventAccountPointsUpdated;
    }
    return self;
}

- (id)initWithPoints:(NSInteger)points {
    self = [self init];
    if(self) {
        self.newPoints = points;
    }
    return self;
}

@end
