//
//  ActiveDisplayScrollView.h
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActiveDisplayScrollViewDelegate;


@interface ActiveDisplayScrollView : UIView<UIScrollViewDelegate>


@property (nonatomic, strong) NSArray *imageItems;
@property (nonatomic, assign) id<ActiveDisplayScrollViewDelegate> delegate;


@end

@protocol ActiveDisplayScrollViewDelegate <NSObject>

@optional
- (void)activeDisplayScrollView:(ActiveDisplayScrollView *)activeDisplayScrollView imagesPageIndexChangedTo:(NSUInteger)pageIndex;
- (void)activeDisplayScrollView:(ActiveDisplayScrollView *)activeDisplayScrollView didTapOnPageIndex:(NSUInteger)pageIndex;

@end
