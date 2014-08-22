//
//  ViewControllerAccessor.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ViewControllerAccessor.h"

@implementation ViewControllerAccessor

@synthesize drawerViewController;

+ (instancetype)defaultAccessor {
    static ViewControllerAccessor *accessor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accessor = [[ViewControllerAccessor alloc] init];
    });
    return accessor;
}

@end
