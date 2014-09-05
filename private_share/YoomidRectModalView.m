//
//  YoomidRectModalView.m
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidRectModalView.h"

@implementation YoomidRectModalView


- (instancetype)initWithSize:(CGSize)size image:(UIImage *)image message:(NSString *)message {
    self = [super initWithSize:size];
    if(self) {
        if(image) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.center = CGPointMake(size.width / 2, 0);
            CGRect frame = imageView.frame;
            frame.origin.y = 10.f;
            imageView.frame = frame;
            [self addSubview:imageView];
        }
    }
    return self;
}



@end
