//
//  PullScrollZoomImagesView.h
//  private_share
//
//  Created by Zhao yang on 6/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageItem.h"

extern CGFloat const kPullImageTopViewHeight;
extern CGFloat const kPullImageBottomViewHeight;

@protocol PullScrollZoomImagesViewDelegate;

@interface PullScrollZoomImagesView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageItems;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL scrollViewLocked;
@property (nonatomic, assign) id<PullScrollZoomImagesViewDelegate> delegate;
@property (nonatomic, strong) UIView *bottomView;

//
- (instancetype)initAndEmbeddedInScrollView:(UIScrollView *)scrollView;
- (instancetype)initAndEmbeddedInScrollView:(UIScrollView *)scrollView viewHeight:(CGFloat)viewHeight;

//
- (void)pullScrollViewDidScroll:(UIScrollView *)scrollView;

//
- (UIScrollView *)scrollView;

- (void)recalculatedPageIndex;

@end

@protocol PullScrollZoomImagesViewDelegate <NSObject>

- (void)pullScrollZoomImagesView:(PullScrollZoomImagesView *)pullScrollZoomImagesView imagesPageIndexChangedTo:(NSUInteger)newPageIndex;

@end

/*

 配置container scroll view 的delegate, 注: psz 是 PullScrollImagesView 实例
 
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    psz.scrollViewLocked = YES;
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [psz pullScrollViewDidScroll:scrollView];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        psz.scrollViewLocked = NO;
    }
 }
 
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    psz.scrollViewLocked = NO;
 }
 
*/
