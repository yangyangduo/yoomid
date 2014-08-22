//
//  ImagesScrollView.m
//  private_share
//
//  Created by Zhao yang on 7/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ImagesScrollView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation ImagesScrollView {
    UIScrollView *scrollView;
    UILabel *titleLabel;
}

@synthesize imageItems = _imageItems_;
@synthesize pageIndex = _pageIndex_;
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.userInteractionEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.3f;
        [self addSubview:maskView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, maskView.frame.origin.y, self.bounds.size.width - 10, 30)];
        titleLabel.text = @"";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setPageIndex:(NSUInteger)pageIndex {
    _pageIndex_ = pageIndex;
}

- (void)setImageItems:(NSArray *)imageItems {
    _imageItems_ = [NSArray arrayWithArray:imageItems];
    for(int i=0; i<scrollView.subviews.count; i++) {
        [[scrollView.subviews objectAtIndex:i] removeFromSuperview];
    }
    for(int i=0; i<_imageItems_.count; i++) {
        ImageItem *imageItem = [_imageItems_ objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width * i, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:imageItem.url] placeholderImage:nil];
        [scrollView addSubview:imageView];
    }
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), scrollView.bounds.size.height);
    _pageIndex_ = 0;
    [self recalculatedPageIndex];
}

- (void)recalculatedPageIndex {
    _pageIndex_ = scrollView.contentOffset.x / scrollView.bounds.size.width;
    ImageItem *item = [self.imageItems objectAtIndex:_pageIndex_];
    titleLabel.text = item.title;
    if(self.delegate != nil) {
        [self.delegate imagesScrollView:self imagesPageIndexChangedTo:_pageIndex_];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        [self recalculatedPageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self recalculatedPageIndex];
}

@end
