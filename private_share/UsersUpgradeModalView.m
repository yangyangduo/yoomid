//
//  UsersUpgradeModalView.m
//  private_share
//
//  Created by 曹大为 on 14-9-17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UsersUpgradeModalView.h"

@implementation UsersUpgradeModalView

- (instancetype) initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if(self) {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500/2, 761/2)];
        bgImageView.image = [UIImage imageNamed:@"bg5"];
        [self addSubview:bgImageView];
        [self setCloseButtonHidden:YES];
    }
    return self;
}

@end
