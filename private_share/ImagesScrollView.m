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
        _pageIndex_ = 0;
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.userInteractionEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
//        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
//        maskView.backgroundColor = [UIColor blackColor];
//        maskView.alpha = 0.3f;
//        [self addSubview:maskView];
        
//        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, maskView.frame.origin.y, self.bounds.size.width - 10, 30)];
//        titleLabel.text = @"";
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.font = [UIFont systemFontOfSize:14.f];
//        titleLabel.textColor = [UIColor whiteColor];
//        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setPageIndex:(NSUInteger)pageIndex {
    _pageIndex_ = pageIndex;
}

- (void)setImageItems:(NSArray *)imageItems {
    if(imageItems != nil) {
        _imageItems_ = [NSArray arrayWithArray:imageItems];
    } else {
        _imageItems_ = [NSArray array];
    }
    
    NSMutableArray *imagesView = [NSMutableArray array];
    for(int i=0; i<scrollView.subviews.count; i++) {
        UIView *view = [scrollView.subviews objectAtIndex:i];
        if(view.tag == 9021) {
            [imagesView addObject:(UIImageView *)view];
        }
    }
    
    BOOL needChangeFrame = _imageItems_.count != imagesView.count;
    
    for(int i=0; i<_imageItems_.count; i++) {
        ImageItem *imageItem = [_imageItems_ objectAtIndex:i];
        UIImageView *imageView = nil;
        
        if(i >= imagesView.count) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width * i, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
            imageView.tag = 9021;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            [imageView addGestureRecognizer:tapGesture];
            [scrollView addSubview:imageView];
#ifdef DEBUG
            NSLog(@"[Image Scroll View] Create image view at index [%d]", i);
#endif
        } else {
            imageView = [imagesView objectAtIndex:i];
        }
        
#ifdef DEBUG
        if(imageView == nil) {
            NSLog(@"[Image Scroll View] Image view in scroll view is nil at index [%d]", i);
        }
#endif
        [imageView setImageWithURL:[NSURL URLWithString:imageItem.url] placeholderImage:nil];
    }
    
    if(imagesView.count > _imageItems_.count) {
        for(int i=0; i<imagesView.count; i++) {
            if(i >= _imageItems_.count) {
                [[imagesView objectAtIndex:i] removeFromSuperview];
#ifdef DEBUG
                NSLog(@"[Image Scroll View] Remove image view at index [%d]", i);
#endif
            }
        }
    }
    [imagesView removeAllObjects];
    
    if(needChangeFrame) {
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * (_imageItems_.count == 0 ? 1 : _imageItems_.count), scrollView.bounds.size.height);
    }
    
    [self recalculatedPageIndex];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
#ifdef DEBUG
    NSLog(@"Tap on page index [%d]", _pageIndex_);
#endif
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(imagesScrollView:didTapOnPageIndex:)]) {
        [self.delegate imagesScrollView:self didTapOnPageIndex:_pageIndex_];
    }
}

- (void)recalculatedPageIndex {
    _pageIndex_ = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if(self.imageItems.count > _pageIndex_) {
        ImageItem *item = [self.imageItems objectAtIndex:_pageIndex_];
        titleLabel.text = item.title;
        if(self.delegate != nil) {
            [self.delegate imagesScrollView:self imagesPageIndexChangedTo:_pageIndex_];
        }
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

- (UIScrollView *)scrollView {
    return scrollView;
}


@end
