//
//  HomePageItemCell.m
//  private_share
//
//  Created by 曹大为 on 14-8-20.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "HomePageItemCell.h"

@implementation HomePageItemCell
{
    UIView *bg_view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];;
        
        _bg_lable = [[UILabel alloc]init];
        _bg_lable.frame = CGRectMake(0, 0, 80, self.bounds.size.height);
        _bg_lable.backgroundColor = [UIColor colorWithRed:43.f/255.f green:51.f/255.f blue:62.f/255.f alpha:1.0f];
        [self addSubview:_bg_lable];
        
        _bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(_bg_lable.bounds.size.width/2-17, _bg_lable.bounds.size.height/2-17, 33, 33)];
        [_bg_lable addSubview:_bg_image];
        
        UIView *rightLineView = [[UIView alloc]initWithFrame:CGRectMake(80, self.bounds.size.height-1, self.bounds.size.width-80, 1.5)];
        rightLineView.backgroundColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
        [self addSubview:rightLineView];
        
        UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-1, 80, 1.5)];
        leftLineView.backgroundColor = [UIColor colorWithRed:59.f / 255.f green:67.f / 255.f blue:77.f / 255.f alpha:1.0f];
        [self addSubview:leftLineView];
        
        _title_lable = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, (self.bounds.size.width-80)/2, self.bounds.size.height)];
        _title_lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title_lable];

        UIView *lable = [[UILabel alloc]initWithFrame:CGRectMake(_bg_lable.frame.size.width+_title_lable.frame.size.width, self.bounds.size.height/2 - 9, 2, 18)];
        lable.backgroundColor = [UIColor colorWithRed:198.f / 255.f green:198.f / 255.f blue:198.f / 255.f alpha:1.0f];
        [self addSubview:lable];
        
        _context = [[UILabel alloc]initWithFrame:CGRectMake(_bg_lable.frame.size.width+_title_lable.frame.size.width+2, 0, (self.bounds.size.width-80)/2-2, self.bounds.size.height)];
        _context.textAlignment = NSTextAlignmentCenter;
        _context.font = [UIFont systemFontOfSize:13.0f];
        _context.textColor = [UIColor colorWithRed:135.f / 255.f green:135.f / 255.f blue:135.f / 255.f alpha:1.0f];
        [self addSubview:_context];
    }
    return self;
}

@end
