//
//  PullScrollZoomImageView.m
//  private_share
//
//  Created by Zhao yang on 6/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PullScrollZoomImageView.h"

CGFloat const kPullImageViewWidth  = 320.f;
CGFloat const kPullImageViewHeight = 280.f;

@implementation PullScrollZoomImageView {
    CGFloat insetTop;
}

@synthesize imageView = _imageView_;

- (instancetype)initAndEmbeddedInScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectMake(0, -kPullImageViewWidth - scrollView.contentInset.top, kPullImageViewWidth, kPullImageViewHeight)];
    if(self) {
        insetTop = scrollView.contentInset.top;
        
        _imageView_ = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView_];
        [scrollView insertSubview:self atIndex:0];
        scrollView.contentInset = UIEdgeInsetsMake(kPullImageViewHeight + insetTop, 0, 0, 0);
        scrollView.contentOffset = CGPointMake(0, -kPullImageViewHeight - insetTop);
    }
    return self;
}

- (void)pullScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y + insetTop;
    if (yOffset < -kPullImageViewHeight) {
        CGFloat factor = ((ABS(yOffset) + kPullImageViewHeight) * (kPullImageViewWidth / 2)) / kPullImageViewHeight;
        CGRect frame = CGRectMake( -(factor - kPullImageViewWidth) / 2, yOffset - insetTop, factor, -yOffset);
        self.frame = frame;
        _imageView_.frame = self.bounds;
    } else if(yOffset <= 0 && yOffset >= -kPullImageViewHeight) {
        CGRect frame;
        if(yOffset != -kPullImageViewHeight - insetTop) {
            frame = self.frame;
            frame.origin.y = (-kPullImageViewHeight - insetTop + ((yOffset + kPullImageViewHeight) / 2));
        } else {
            frame = CGRectMake(0, -kPullImageViewHeight - insetTop, kPullImageViewWidth, kPullImageViewHeight);
        }
        self.frame = frame;
        _imageView_.frame = self.bounds;
    }
}

@end
