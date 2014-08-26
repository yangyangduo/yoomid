//
//  XiaojiRecommendTableViewCell.m
//  private_share
//
//  Created by 曹大为 on 14-8-26.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XiaojiRecommendTableViewCell.h"

@implementation XiaojiRecommendTableViewCell
{
    UIImageView *imageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor grayColor];
        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 370)];
        bgImage.image = [UIImage imageNamed:@"shopbg2"];
        [self addSubview:bgImage];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, 360)];
        imageView.image = [UIImage imageNamed:@"xiaojibg"];
        [self addSubview:imageView];
        
        UIImageView *mikuImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 31, 31)];
        mikuImage.image = [UIImage imageNamed:@"miku3"];
        [imageView addSubview:mikuImage];
        
        UIImageView *goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(51, 10, 31, 31)];
        goodImage.image = [UIImage imageNamed:@"good2"];
        [imageView addSubview:goodImage];
        
        UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeBtn.frame = CGRectMake(imageView.bounds.size.width-94, imageView.bounds.size.height-35, 94, 35);
        [exchangeBtn setTitle:@"我要兑换" forState:UIControlStateNormal];
        [exchangeBtn setTintColor:[UIColor whiteColor]];
        [exchangeBtn setImage:[UIImage imageNamed:@"exchange"] forState:UIControlStateNormal];
        [imageView addSubview:exchangeBtn];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
