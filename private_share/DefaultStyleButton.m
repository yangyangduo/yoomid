//
//  DefaultStyleButton.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DefaultStyleButton.h"

@implementation DefaultStyleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
        self.titleEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
    }
    return self;
}

@end
