//
//  XiaoJiRecommendView.m
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XiaoJiRecommendView.h"
#import "UIColor+App.h"
#import "XiaoJiMerchandisesDetailsView.h"

@implementation XiaoJiRecommendView
{
    UILabel *shopName;
    
    NSMutableArray *views;
}

@synthesize recommendedMerchandises = _recommendedMerchandises;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        views = [[NSMutableArray alloc] init];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
//        moreBtn.backgroundColor = [UIColor redColor];
        [moreBtn addTarget:self action:@selector(actionMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:moreBtn];
        
        shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 100, 23)];
        shopName.text = @"小吉推荐";
        shopName.font = [UIFont systemFontOfSize:16.f];
        shopName.textColor = [UIColor appLightBlue];
        shopName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:shopName];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-45, -15, 121/2, 121/2)];
        leftImage.image = [UIImage imageNamed:@"into"];
        [self addSubview:leftImage];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 30, self.bounds.size.width, 1.0)];
        lineView1.backgroundColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
        [self addSubview:lineView1];
        
        CGFloat viewWidthOrHeight = self.bounds.size.width/3;

        for (int i = 0; i < 3; i++) {
            XiaoJiMerchandisesDetailsView *xiaoji1 = [[XiaoJiMerchandisesDetailsView alloc] initWithFrame:CGRectMake(i*viewWidthOrHeight, 31, viewWidthOrHeight, viewWidthOrHeight+50)];
            xiaoji1.tag = i;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            [views addObject:xiaoji1];
            [xiaoji1 addGestureRecognizer:tapGesture];
            [self addSubview:xiaoji1];
        }
    }
    return self;
}

- (void)setRecommendedMerchandises:(NSMutableArray *)recommendedMerchandises
{
    if (recommendedMerchandises != nil) {
        _recommendedMerchandises = [NSMutableArray arrayWithArray:recommendedMerchandises] ;
    }else{
        _recommendedMerchandises = [NSMutableArray array];
    }
    
    for (int i = 0; i<3; i++) {
        XiaoJiMerchandisesDetailsView *view = [views objectAtIndex:i];
        view.merchandise = [_recommendedMerchandises objectAtIndex:i];
    }
}

- (void)actionMoreBtn:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickMoreXiaoJiRecommend)]) {
        [self.delegate didClickMoreXiaoJiRecommend];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    UIView *viewClicked=[tapGesture view];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickXiaoJiMerchandise:)]) {
        [self.delegate didClickXiaoJiMerchandise:viewClicked.tag];
    }
}
@end
