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

/*
 
 **** 一般使用
 此控件是嵌入到scroll view 的顶部, 用于显示图片的, 下拉scroll view图片会慢慢变大
 只需要调用  initAndEmbeddedInScrollView 这个方法 并传入 scroll view
 然后在 scroll view 的 delegate 的 scrollViewDidScroll 方法中 调用 此控件的 pullScrollViewDidScroll:方法即可
 
 
 **** 对于scroll view 顶部不单单只有此控件一个UIView的情况下
 类似于(top image view + custom view + htmlview(所说得pull scroll view))
 要先创建并加入 custom view, 并指定好 contentInset
 然后最后再按前面的方法使用即可
 
 */

