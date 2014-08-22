//
// Created by Zhao yang on 5/27/14.
// Copyright (c) 2014 hentre. All rights reserved.
//

#import "UIDevice+SystemVersion.h"

@implementation UIDevice (SystemVersion)

+ (BOOL)systemVersionIsMoreThanOrEuqal7 {
    return [UIDevice currentDevice].systemVersion.floatValue >= 7.0f;
}

@end