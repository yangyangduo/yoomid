//
//  UIDevice+ScreenSize.m
//  private_share
//
//  Created by Zhao yang on 7/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UIDevice+ScreenSize.h"

@implementation UIDevice (ScreenSize)

+ (BOOL)is4InchDevice {
    return [UIScreen mainScreen].bounds.size.height == 568.f;
}

@end
