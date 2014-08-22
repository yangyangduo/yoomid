//
//  PullScrollZoomImagesView.m
//  private_share
//
//  Created by Zhao yang on 6/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PullScrollZoomImagesView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

CGFloat const kPullImageTopViewHeight = 64.f;
CGFloat const kPullImageBottomViewHeight = 30.f;

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation PullScrollZoomImagesView {
    CGFloat _view_height_;
    
    CGFloat insetTop;
    UIScrollView *imagesScrollView;
    __weak UIScrollView *containerScrollView;
}

@synthesize imageItems = _imageItems_;
@synthesize pageIndex = _pageIndex_;
@synthesize scrollViewLocked = _scrollViewLocked_;
@synthesize bottomView = _bottomView_;
@synthesize delegate;

- (instancetype)initAndEmbeddedInScrollView:(UIScrollView *)scrollView {
    self = [self initAndEmbeddedInScrollView:scrollView viewHeight:240];
    if(self) {
        // ...
    }
    return self;
}

- (instancetype)initAndEmbeddedInScrollView:(UIScrollView *)scrollView viewHeight:(CGFloat)viewHeight {
    self = [super initWithFrame:CGRectMake(0, -viewHeight - scrollView.contentInset.top, SCREEN_WIDTH, viewHeight)];
    if(self) {
        _view_height_ = viewHeight;
        insetTop = scrollView.contentInset.top;
        
        //
        containerScrollView = scrollView;
        
        //
        imagesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        imagesScrollView.pagingEnabled = YES;
        imagesScrollView.showsVerticalScrollIndicator = NO;
        imagesScrollView.showsHorizontalScrollIndicator = NO;
        imagesScrollView.userInteractionEnabled = YES;
        imagesScrollView.delegate = self;
        [self addSubview:imagesScrollView];
        
        //
        [scrollView insertSubview:self atIndex:0];
        scrollView.contentInset = UIEdgeInsetsMake(_view_height_ + insetTop, 0, 0, 0);
        scrollView.contentOffset = CGPointMake(0, -_view_height_ - insetTop);
        
        _bottomView_ = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kPullImageBottomViewHeight, self.bounds.size.width, kPullImageBottomViewHeight)];
        _bottomView_.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomView_];
    }
    return self;
}

- (void)setImageItems:(NSArray *)imageItems {
    _imageItems_ = [NSArray arrayWithArray:imageItems];
    for(int i=0; i<imagesScrollView.subviews.count; i++) {
        [[imagesScrollView.subviews objectAtIndex:i] removeFromSuperview];
    }
    for(int i=0; i<_imageItems_.count; i++) {
        ImageItem *imageItem = [_imageItems_ objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imagesScrollView.bounds.size.width * i, 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:imageItem.url] placeholderImage:nil];
        [imagesScrollView addSubview:imageView];
    }
    imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), imagesScrollView.bounds.size.height);
    _pageIndex_ = 0;
}

- (void)setPageIndex:(NSUInteger)pageIndex {
    _pageIndex_ = pageIndex;
}

- (void)pullScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y + insetTop;
    if (yOffset < -_view_height_) {
        CGFloat factor = ((ABS(yOffset) + _view_height_) * (SCREEN_WIDTH / 2)) / _view_height_;
        CGFloat xOffset = (factor - SCREEN_WIDTH) / 2;
        CGRect frame = CGRectMake(-xOffset, yOffset - insetTop, factor, -yOffset);
        
        // set self frame
        self.frame = frame;
        
        // set title view frame
        if(_bottomView_) {
            _bottomView_.frame = CGRectMake(-self.frame.origin.x, self.bounds.size.height - kPullImageBottomViewHeight, SCREEN_WIDTH, kPullImageBottomViewHeight);
        }
        
        // set scroll view frame
        imagesScrollView.frame = self.bounds;
        imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), imagesScrollView.bounds.size.height);
        imagesScrollView.contentOffset = CGPointMake(imagesScrollView.bounds.size.width * self.pageIndex, 0);
        
        // set scroll view content frame
        for(int i=0; i<imagesScrollView.subviews.count; i++) {
            UIView *imageView = [imagesScrollView.subviews objectAtIndex:i];
            imageView.frame = CGRectMake(imagesScrollView.bounds.size.width * i , 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height);
        }
    } else if(yOffset <= 0 && yOffset >= -_view_height_) {
        CGRect frame;
        if(yOffset != -_view_height_ - insetTop) {
            frame = CGRectMake(0, 0, SCREEN_WIDTH, _view_height_);
            frame.origin.y = (-_view_height_ - insetTop + ((yOffset + _view_height_) / 2));
        } else {
            frame = CGRectMake(0, -_view_height_ - insetTop, SCREEN_WIDTH, _view_height_);
        }
        
        self.frame = frame;
        
        if(_bottomView_) {
            _bottomView_.frame = CGRectMake(-self.frame.origin.x, self.bounds.size.height - kPullImageBottomViewHeight, SCREEN_WIDTH, kPullImageBottomViewHeight);
        }
        
        imagesScrollView.frame = self.bounds;
        imagesScrollView.contentSize = CGSizeMake(imagesScrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), imagesScrollView.bounds.size.height);
        imagesScrollView.contentOffset = CGPointMake(imagesScrollView.bounds.size.width * self.pageIndex, 0);
        for(int i=0; i<imagesScrollView.subviews.count; i++) {
            UIView *imageView = [imagesScrollView.subviews objectAtIndex:i];
            imageView.frame = CGRectMake(imagesScrollView.bounds.size.width * i , 0, imagesScrollView.bounds.size.width, imagesScrollView.bounds.size.height);
        }
    }
}

- (void)setScrollViewLocked:(BOOL)scrollViewLocked {
    _scrollViewLocked_ = scrollViewLocked;
    if(_scrollViewLocked_) {
        imagesScrollView.scrollEnabled = NO;
    } else {
        imagesScrollView.scrollEnabled = YES;
    }
}

- (void)recalculatedPageIndex {
    _pageIndex_ = floor(imagesScrollView.contentOffset.x) / floor(imagesScrollView.bounds.size.width);
    if(self.delegate != nil) {
        [self.delegate pullScrollZoomImagesView:self imagesPageIndexChangedTo:_pageIndex_];
    }
}

- (UIScrollView *)scrollView {
    return imagesScrollView;
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(self.scrollViewLocked) return;
    if(containerScrollView) {
        containerScrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(self.scrollViewLocked) return;
    if(!decelerate) {
        [self recalculatedPageIndex];
        containerScrollView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(self.scrollViewLocked) return;
    [self recalculatedPageIndex];
    containerScrollView.scrollEnabled = YES;
}

@end
