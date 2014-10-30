//
//  XiaoJiRecommendView.h
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XiaoJiRecommendViewDelegate;

@interface XiaoJiRecommendView : UIView

@property (nonatomic, strong) NSMutableArray *recommendedMerchandises;
@property (nonatomic, assign) id<XiaoJiRecommendViewDelegate> delegate;

@end

@protocol XiaoJiRecommendViewDelegate <NSObject>

- (void)didClickMoreXiaoJiRecommend;
- (void)didClickXiaoJiMerchandise:(NSInteger)index;
@end
