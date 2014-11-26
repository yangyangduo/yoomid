//
//  MerchandiseTemplateFourCell.m
//  private_share
//
//  Created by 曹大为 on 14/11/18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "MerchandiseTemplateFourCell.h"
#import "UIColor+App.h"
#import "UnderlinedLabel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MerchandiseTemplateFourCell
{
    UIImageView *shopImage;
    UILabel *shopName;
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
        
        shopImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bg_view.bounds.size.width, bg_view.bounds.size.width)];
//        shopImage.image = [UIImage imageNamed:@"daohangs4"];
        [bg_view addSubview:shopImage];
    
        shopName = [[UILabel alloc] initWithFrame:CGRectMake(2, shopImage.bounds.size.height, shopImage.bounds.size.width, 25)];
        shopName.textAlignment = NSTextAlignmentLeft;
        shopName.font = [UIFont systemFontOfSize:12.f];
        shopName.textColor = [UIColor blackColor];
//        shopName.text = @"女士单肩手提时尚包包";
        [bg_view addSubview:shopName];
        
        shopPrice = [[UILabel alloc] initWithFrame:CGRectMake(2, shopName.frame.origin.y+16.5, 40, 25)];
        shopPrice.textAlignment = NSTextAlignmentLeft;
        shopPrice.font = [UIFont systemFontOfSize:12.f];
        shopPrice.textColor = [UIColor appLightBlue];
//        shopPrice.text = @"¥ 200";
        [bg_view addSubview:shopPrice];
        
        originalPrice = [[UnderlinedLabel alloc] initWithFrame:CGRectMake(shopPrice.frame.origin.x + shopPrice.bounds.size.width+2, shopPrice.frame.origin.y, 80, 25)];
        originalPrice.textAlignment = NSTextAlignmentLeft;
        originalPrice.textColor = [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.0f];
//        originalPrice.text = @"280.0";
        originalPrice.font = [UIFont systemFontOfSize:12.f];
        originalPrice.lineType = LineTypeMiddle;
        [bg_view addSubview:originalPrice];
    }
    return self;
}

-(void)setMerchandise:(Merchandise *)merchandise
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
