//
//  DefaultStyleTextField.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DefaultStyleTextField.h"
#import "UIDevice+SystemVersion.h"

@implementation DefaultStyleTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if(![UIDevice systemVersionIsMoreThanOrEqual7]) {
        return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 11, bounds.size.width - 43, bounds.size.height - 7);
    } else {
        return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 4, bounds.size.width - 43, bounds.size.height - 7);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect superFrame = [super clearButtonRectForBounds:bounds];
    return CGRectMake(superFrame.origin.x - 2, superFrame.origin.y, superFrame.size.width, superFrame.size.height);
}

@end
