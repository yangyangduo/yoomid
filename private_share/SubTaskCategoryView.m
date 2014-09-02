//
//  SubTaskCategoryView.m
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SubTaskCategoryView.h"
#import "UIColor+App.h"

@implementation SubTaskCategoryView {
}

@synthesize scrollView = _scrollView_;

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 44)];
        titleView.backgroundColor = [UIColor appColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, titleView.bounds.size.width - 30, 40)];
        titleLabel.text = @"安装应用获得丰厚奖励";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.textColor = [UIColor appLightBlue];
        [titleView addSubview:titleLabel];
        [self.contentView addSubview:titleView];

        _scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleView.bounds.size.height, titleView.bounds.size.width, self.contentView.bounds.size.height - titleView.bounds.size.height)];
        _scrollView_.alwaysBounceVertical = YES;
        
        _scrollView_.contentSize = _scrollView_.bounds.size;
        _scrollView_.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_scrollView_];
    }
    return self;
}

- (void)addSubviewInScrollView:(UIView *)view {
    [_scrollView_ addSubview:view];
}

@end
