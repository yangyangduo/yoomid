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
#import "DiskCacheManager.h"
#import "XXAlertView.h"
#import "UIColor+App.h"

#define DEFAULT_IMAGE [UIImage imageNamed:@"merchandise_placeholder"]

@implementation XiaojiRecommendTableViewCell
{
    UIImageView *imageView;
    UILabel *merchandiseName;
}

@synthesize merchandise = _merchandise;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.backgroundColor = [UIColor clearColor];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20,400)];
//        imageView.image = [UIImage imageNamed:@"xiaojibg"];
        [self addSubview:imageView];
//        
//        UIImageView *mikuImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 31, 31)];
//        mikuImage.image = [UIImage imageNamed:@"miku3"];
//        [imageView addSubview:mikuImage];
        
//        UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        goodBtn.frame = CGRectMake(20, 10, 51/2, 51/2);
//        [goodBtn setImage:[UIImage imageNamed:@"good2"] forState:UIControlStateNormal];
//        [goodBtn addTarget:self action:@selector(actionGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:goodBtn];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, imageView.bounds.size.height-35, imageView.bounds.size.width, 35)];
        bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_gray_transport_big"]];
//        bottomView.alpha = 0.6f;
        [self addSubview:bottomView];
        
        self.zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(53, 10, 25, 25)];
        [self.zanLabel setTextColor:[UIColor appLightBlue]];
        [self addSubview:self.zanLabel];
        
        merchandiseName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300 - 104, 35)];
        merchandiseName.textColor = [UIColor whiteColor];
        merchandiseName.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:merchandiseName];
        
        UIImageView *exchangeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(bottomView.bounds.size.width-94, -13.5, 94, 48)];
        exchangeImageView.image = [UIImage imageNamed:@"exchange"];
//        exchangeImageView.layer.
        [bottomView addSubview:exchangeImageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(8, 13.5, 95, 35)];
        lable.text = @"我要兑";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:14.f];
        [exchangeImageView addSubview:lable];
        
//        UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        exchangeBtn.frame = CGRectMake(bottomView.bounds.size.width-94, -13, 94, 48);
//        [exchangeBtn setTitle:@"我要兑换" forState:UIControlStateNormal];
//        [exchangeBtn setTintColor:[UIColor whiteColor]];
//        exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
//        [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"exchange"] forState:UIControlStateNormal];
//        [exchangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 15, 0, 0)];
//        [bottomView addSubview:exchangeBtn];
    }
    return self;
}
/*
- (void)actionGoodBtn:(id)sender
{
    NSLog(@"赞按钮的tag值：%d", [((UIButton*)sender) tag]);
    //
    NSString *merchandisesStr = @"94695736c0ee48e4ba48c55b157754e7";

    //从本地缓存中取出已点赞的商品id
    NSMutableArray *merchandisesIds = nil;
    NSArray *cacheData = [DiskCacheManager manager].merchandisesIds;
    if (cacheData == nil) {
        merchandisesIds = [NSMutableArray array];
    }
    else{
        merchandisesIds = [NSMutableArray arrayWithArray:cacheData];
    }
    
    if (merchandisesIds.count == 0) {
        [merchandisesIds addObject:merchandisesStr];
        [[DiskCacheManager manager] setMerchandisesIds:merchandisesIds];
    }
    else{
        BOOL isZan = NO;
        for (int i = 0; i<merchandisesIds.count; i++) {
            NSString *merchandisesIdStr = [merchandisesIds objectAtIndex:i];
            if ([merchandisesStr isEqualToString:merchandisesIdStr]) {
                isZan = YES;
                break;
            }
        }
        
        if (isZan) {
            [[XXAlertView currentAlertView] setMessage:@"您已经赞过该商品了" forType:AlertViewTypeSuccess];
            [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            return;
        }else{
            //.....没赞过
            
        }
        
    }
    return;
    MerchandiseService *service = [[MerchandiseService alloc]init];
    [service sendGoodWithMerchandiseId:merchandisesStr target:self success:@selector(sendGoodSuccess:) failure:@selector(handleFailure:) userInfo:nil];
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
*/
- (void)setMerchandise:(Merchandise *)merchandise
{
    if(merchandise == nil) return;
    if(merchandise.imageUrls == nil || merchandise.imageUrls.count == 0) {
        imageView.image = DEFAULT_IMAGE;
        self.zanLabel.text = @"";
        merchandiseName.text = @"";
    } else {
//        NSString *displayedImageUrl = [merchandise.imageUrls objectAtIndex:0];
        NSString *displayedImageUrl = [merchandise secondImageUrl];
        [imageView setImageWithURL:[NSURL URLWithString:displayedImageUrl] placeholderImage:DEFAULT_IMAGE];
        self.zanLabel.text = [NSString stringWithFormat:@"%d",merchandise.follows];
        merchandiseName.text = merchandise.name;
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
