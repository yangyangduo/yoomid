//
//  ActiveDisplayScrollView.m
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ActiveDisplayScrollView.h"
#import "UIColor+App.h"

@implementation ActiveDisplayScrollView
{
    UIScrollView *_scrollView;
    UIPageControl *pageControl;
    NSTimer *_timer;
}

@synthesize imageItems = _imageItems;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 -50,self.bounds.size.height - 25,100,18)]; // 初始化mypagecontrol
        [pageControl setCurrentPageIndicatorTintColor:[UIColor appLightBlue]];
        [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        //        [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
        [self addSubview:pageControl];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        

    }
    return self;
}

- (void)setImageItems:(NSArray *)imageItems
{
    if(imageItems != nil) {
        _imageItems = [NSArray arrayWithArray:imageItems];
    } else {
        _imageItems = [NSArray array];
    }
    
    if (_imageItems.count > 0) {
        pageControl.numberOfPages = [_imageItems count];
        pageControl.currentPage = 0;
    }
    
    for (int i = 0 ; i < _imageItems.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width * i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        imageView.tag = 9021;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.image = [imageItems objectAtIndex:i];
        [_scrollView addSubview:imageView];
    }
    
    [_scrollView setContentSize:CGSizeMake(self.bounds.size.width * [_imageItems count], self.bounds.size.height)]; //
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
}

// scrollview 委托函数  滑动结束后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    pageControl.currentPage = currentPage;
    
    //    NSLog(@"当前页面:%d",currentPage);
}

// 定时器 绑定的方法
- (void)runTimePage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    page++;
    page = page >= _imageItems.count ? 0 : page ;
    pageControl.currentPage = page;
    //    NSLog(@"page:%d,imagecount:%ld",page,_imageItems.count);
    [_scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width*page,0,self.bounds.size.width,self.bounds.size.height) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
    //    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width*pageControl.currentPage, 0)];
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
#ifdef DEBUG
    NSLog(@"点击的page是:%d",pageControl.currentPage);
#endif
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(activeDisplayScrollView:didTapOnPageIndex:)]) {
        [self.delegate activeDisplayScrollView:self didTapOnPageIndex:pageControl.currentPage];
    }
}

@end

