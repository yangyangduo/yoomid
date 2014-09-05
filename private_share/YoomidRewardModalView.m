//
//  YoomidRewardModalView.m
//  private_share
//
//  Created by Zhao yang on 9/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidRewardModalView.h"

@implementation YoomidRewardModalView

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *backgroundImage = [UIImage imageNamed:@"modal_background"];
        backgroundImageView.image = backgroundImage;
        [self addSubview:backgroundImageView];
        
        //[UIImage imageWithContentsOfFile:@""];
    }
    return self;
}

@end
