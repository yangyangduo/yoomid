//
//  DrawerViewControllerConfig.m
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DrawerViewControllerConfig.h"

@implementation DrawerViewControllerConfig

@synthesize triggerShowDrawerViewMinWidth;
@synthesize leftDrawerViewVisibleWidth;
@synthesize triggerHideLeftDrawerViewX;
@synthesize rightDrawerViewVisibleWidth;
@synthesize triggerHideRightDrawerViewX;

+ (DrawerViewControllerConfig *)defaultConfig {
    static DrawerViewControllerConfig *defaultConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultConfig = [[DrawerViewControllerConfig alloc] init];
    });
    return defaultConfig;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.triggerShowDrawerViewMinWidth = 60;
        self.leftDrawerViewVisibleWidth = 220;
        self.triggerHideLeftDrawerViewX = 160;
        self.rightDrawerViewVisibleWidth = 260;
        self.triggerHideRightDrawerViewX = 120;
    }
    return self;
}

@end
