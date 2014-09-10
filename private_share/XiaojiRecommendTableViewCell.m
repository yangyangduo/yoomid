//
//  XiaojiRecommendTableViewCell.m
//  private_share
//
//  Created by 曹大为 on 14-8-26.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XiaojiRecommendTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define DEFAULT_IMAGE [UIImage imageNamed:@"merchandise_placeholder"]

@implementation XiaojiRecommendTableViewCell
{
    UIImageView *imageView;
}

@synthesize merchandise = _merchandise;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.backgroundColor = [UIColor clearColor];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, [UIDevice is4InchDevice] ? 400 : 325)];
//        imageView.image = [UIImage imageNamed:@"xiaojibg"];
        [self addSubview:imageView];
//        
//        UIImageView *mikuImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 31, 31)];
//        mikuImage.image = [UIImage imageNamed:@"miku3"];
//        [imageView addSubview:mikuImage];
        
        UIImageView *goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 31, 31)];
        goodImage.image = [UIImage imageNamed:@"good2"];
        [imageView addSubview:goodImage];
        
        UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeBtn.frame = CGRectMake(imageView.bounds.size.width-94, imageView.bounds.size.height-35, 94, 35);
        [exchangeBtn setTitle:@"我要兑换" forState:UIControlStateNormal];
        [exchangeBtn setTintColor:[UIColor whiteColor]];
        exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"exchange"] forState:UIControlStateNormal];
        [exchangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 15, 0, 0)];
        [imageView addSubview:exchangeBtn];
    }
    return self;
}

- (void)setMerchandise:(Merchandise *)merchandise
{
    if(merchandise == nil) return;
    if(merchandise.imageUrls == nil || merchandise.imageUrls.count == 0) {
        imageView.image = DEFAULT_IMAGE;
    } else {
        NSString *displayedImageUrl = [merchandise.imageUrls objectAtIndex:0];
        [imageView setImageWithURL:[NSURL URLWithString:displayedImageUrl] placeholderImage:DEFAULT_IMAGE];
    }
    
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
