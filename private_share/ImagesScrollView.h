//
//  ImagesScrollView.h
//  private_share
//
//  Created by Zhao yang on 7/8/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageItem.h"

@protocol ImagesScrollViewDelegate;

@interface ImagesScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageItems;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) id<ImagesScrollViewDelegate> delegate;
- (UIScrollView *)scrollView;

@end

@protocol ImagesScrollViewDelegate <NSObject>

@optional

- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView imagesPageIndexChangedTo:(NSUInteger)pageIndex;
- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView didTapOnPageIndex:(NSUInteger)pageIndex;

@end
