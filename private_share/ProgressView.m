//
//  ProgressView.m
//  private_share
//
//  Created by Zhao yang on 7/7/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ProgressView.h"
#import "UIColor+App.h"

@implementation ProgressView

@synthesize trackView;
@synthesize backgroundView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor appColor];
        
        CGRect _frame_ = self.bounds;
        _frame_.size.width = self.bounds.size.width * 0.75f;
        trackView = [[UIView alloc] initWithFrame:_frame_];
        trackView.backgroundColor = [UIColor lightGrayColor];
        
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        
        [self addSubview:backgroundView];
        [self addSubview:trackView];
    }
    return self;
}

- (void)setProgress:(float)progress {
    if(progress > 1.f) progress = 1.f;
    CGRect frame = trackView.frame;
    frame.size.width = self.bounds.size.width * progress;
    trackView.frame = frame;
}

@end
