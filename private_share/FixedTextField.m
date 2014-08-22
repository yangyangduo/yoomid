//
//  FixedTextField.m
//  private_share
//
//  Created by Zhao yang on 6/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "FixedTextField.h"
#import "UIDevice+SystemVersion.h"

@implementation FixedTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    if(![UIDevice systemVersionIsMoreThanOrEqual7]) {
        return CGRectMake(bounds.origin.x, bounds.origin.y + 9, bounds.size.width - 35, bounds.size.height);
    }
    return [super textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
