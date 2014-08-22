//
//  ButtonUtil.m
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ButtonUtil.h"

@implementation ButtonUtil

+ (UIButton *)newTestButton {
    UIButton *btnTest = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 120, 30)];
    [btnTest setTitle:@"Test" forState:UIControlStateNormal];
    [btnTest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTest setBackgroundColor:[UIColor darkGrayColor]];
    btnTest.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btnTest;
}

+ (UIButton *)newTestButtonForTarget:(id)target action:(SEL)action {
    UIButton *btnTest = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 120, 30)];
    [btnTest setTitle:@"Test" forState:UIControlStateNormal];
    [btnTest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTest setBackgroundColor:[UIColor darkGrayColor]];
    btnTest.titleLabel.textAlignment = NSTextAlignmentCenter;
    if(target != nil && action != nil) {
        [btnTest addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btnTest;
}

@end
