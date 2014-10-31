//
//  NewHomePageItemCell.m
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "NewHomePageItemCell.h"

@implementation NewHomePageItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width  , frame.size.height)];
        [self addSubview:_bg_image];
    }
    return self;
}
@end
