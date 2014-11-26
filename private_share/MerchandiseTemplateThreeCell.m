//
//  MerchandiseTemplateThreeCell.m
//  private_share
//
//  Created by 曹大为 on 14/11/17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "MerchandiseTemplateThreeCell.h"
#import "UIColor+App.h"
#import "UnderlinedLabel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MerchandiseTemplateThreeCell
{
    UILabel *shopName;
    UIImageView *shopImage;
    UILabel *shopPrice;
    UnderlinedLabel *originalPrice;
}

@synthesize merchandise = _merchandise_;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bg_view = [[UIView alloc] initWithFrame:CGRectMake(2.5, 5, frame.size.width-5, frame.size.height-5)];
        bg_view.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:bg_view];
        
        shopName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bg_view.bounds.size.width, 25)];
        shopName.textAlignment = NSTextAlignmentCenter;
//        shopName.text = @"PINPAI";
        [bg_view addSubview:shopName];
        
        CGFloat viewHeight = frame.size.width - 50;
        
        shopImage = [[UIImageView alloc] initWithFrame:CGRectMake(22.5, 25, viewHeight, viewHeight)];
//        shopImage.image = [UIImage imageNamed:@"daohangs4"];
        [bg_view addSubview:shopImage];
        
        shopPrice = [[UILabel alloc] initWithFrame:CGRectMake(shopImage.frame.origin.x, 25+viewHeight, shopImage.bounds.size.width/2, 20)];
        shopPrice.textAlignment = NSTextAlignmentRight;
        shopPrice.font = [UIFont systemFontOfSize:12.5f];
        shopPrice.textColor = [UIColor appLightBlue];
//        shopPrice.text = @"¥ 200";
        [bg_view addSubview:shopPrice];
        
        originalPrice = [[UnderlinedLabel alloc] initWithFrame:CGRectMake(shopImage.frame.origin.x + shopPrice.bounds.size.width+2, shopPrice.frame.origin.y, shopImage.bounds.size.width/2, 20)];
        originalPrice.textAlignment = NSTextAlignmentLeft;
        originalPrice.textColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
//        originalPrice.text = @"280.0";
        originalPrice.font = [UIFont systemFontOfSize:13.f];
        originalPrice.lineType = LineTypeMiddle;
        [bg_view addSubview:originalPrice];
    }
    return self;
}

- (void)setMerchandise:(Merchandise *)merchandise
{
    if (merchandise == nil) {
        shopName.text = @"";
        shopImage.image = [UIImage imageNamed:@"image_loading_gray"];
        shopPrice.text = @"";
        originalPrice.text = @"";
    }else{
        if(merchandise.imageUrls == nil || merchandise.imageUrls.count == 0) {
            shopImage.image = [UIImage imageNamed:@"image_loading_gray"];
        } else {
            NSString *displayedImageUrl = [merchandise.imageUrls objectAtIndex:0];
            [shopImage setImageWithURL:[NSURL URLWithString:displayedImageUrl] placeholderImage:[UIImage imageNamed:@"image_loading_gray"]];
        }
        
        shopName.text = merchandise.name;
        shopPrice.text = [NSString stringWithFormat:@"¥ %.1f",merchandise.price];
        originalPrice.text = [NSString stringWithFormat:@"%.1f",merchandise.originalPrice];
    }
}

@end
