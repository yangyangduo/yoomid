//
//  PullScrollZoomImageHtmlView.m
//  private_share
//
//  Created by Zhao yang on 6/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PullScrollZoomImageHtmlView.h"
#import "PullScrollZoomImageView.h"

@implementation PullScrollZoomImageHtmlView {
    PullScrollZoomImageView *pullScrollZoomImageView ;
}

- (instancetype)initWithFrame:(CGRect)frame headerView:(UIView *)headerView {
    self = [super initWithFrame:frame];
    if(self) {
        if(headerView != nil) {
            CGRect _frame_ = headerView.frame;
            _frame_.origin.x = 0;
            _frame_.origin.y = -_frame_.size.height;
            headerView.frame = _frame_;
            [self.scrollView insertSubview:headerView atIndex:0];
            self.scrollView.contentInset = UIEdgeInsetsMake(_frame_.size.height, 0, 0, 0);
        }
        
        pullScrollZoomImageView = [[PullScrollZoomImageView alloc] initAndEmbeddedInScrollView:self.scrollView];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(pullScrollZoomImageView) {
        [pullScrollZoomImageView pullScrollViewDidScroll:scrollView];
    }
}

@end
