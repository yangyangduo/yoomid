//
//  XiaojiRecommendTableViewCell.m
//  private_share
//
//  Created by 曹大为 on 14-8-26.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XiaojiRecommendTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MerchandiseService.h"

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

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20,((self.bounds.size.width-20)/3)*4)];
//        imageView.image = [UIImage imageNamed:@"xiaojibg"];
        [self addSubview:imageView];
//        
//        UIImageView *mikuImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 31, 31)];
//        mikuImage.image = [UIImage imageNamed:@"miku3"];
//        [imageView addSubview:mikuImage];
        static int i = 1;
        
        UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goodBtn.frame = CGRectMake(20, 10, 51/2, 51/2);
        goodBtn.tag = i;
        [goodBtn setImage:[UIImage imageNamed:@"good2"] forState:UIControlStateNormal];
        [goodBtn addTarget:self action:@selector(actionGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goodBtn];
        
        i++;
        
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

- (void)actionGoodBtn:(id)sender
{
    int s = [((UIButton*)sender) tag];
//    return;
    MerchandiseService *service = [[MerchandiseService alloc]init];
    [service sendGoodWithMerchandiseId:@"94695736c0ee48e4ba48c55b157754e7" target:self success:@selector(sendGoodSuccess:) failure:@selector(handleFailure:) userInfo:nil];
}

- (void)sendGoodSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200) {
        NSLog(@"赞成功");
        NSNumber *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSInteger number = jsonArray.integerValue;

//        MerchandiseService *service = [[MerchandiseService alloc]init];
//        [service getGoodWithMerchandiseId:@"94695736c0ee48e4ba48c55b157754e7" target:self success:@selector(getGoodSuccess:) failure:@selector(handleFailure:) userInfo:nil];
    }
}

- (void)getGoodSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200) {
        NSNumber *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSInteger number = jsonArray.integerValue;
    }
}

- (void)setMerchandise:(Merchandise *)merchandise
{
    if(merchandise == nil) return;
    if(merchandise.imageUrls == nil || merchandise.imageUrls.count == 0) {
        imageView.image = DEFAULT_IMAGE;
    } else {
//        NSString *displayedImageUrl = [merchandise.imageUrls objectAtIndex:0];
        NSString *displayedImageUrl = [merchandise secondImageUrl];
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
