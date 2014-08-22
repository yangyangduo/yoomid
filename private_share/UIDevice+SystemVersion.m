//
//  UIDevice+SystemVersion.m
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UIDevice+SystemVersion.h"

@implementation UIDevice (SystemVersion)

+ (BOOL)systemVersionIsMoreThanOrEqual7 {
    return [UIDevice currentDevice].systemVersion.floatValue >= 7.0f;
}

@end
