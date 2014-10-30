//
//  XiaoJiMerchandisesDetailsView.m
//  private_share
//
//  Created by 曹大为 on 14/10/30.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "XiaoJiMerchandisesDetailsView.h"
#import "UIColor+App.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define DEFAULT_IMAGES [UIImage imageNamed:@"image_loading_gray"]

@implementation XiaoJiMerchandisesDetailsView
{
    UIImageView *merchandiseImage;
    UILabel *merchandisePrice;
    UILabel *merchandisePoints;

}

@synthesize merchandise = _merchandise;

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        merchandiseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        [self addSubview:merchandiseImage];
        
        merchandisePrice = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.width, self.bounds.size.width, 20)];
        merchandisePrice.textAlignment = NSTextAlignmentCenter;
        merchandisePrice.textColor = [UIColor appLightBlue];
        [self addSubview:merchandisePrice];
        
        merchandisePoints = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.width+20, self.bounds.size.width, 20)];
        merchandisePoints.textAlignment = NSTextAlignmentCenter;
        merchandisePoints.textColor = [UIColor appLightBlue];

        [self addSubview:merchandisePoints];
    }
    return self;
}

- (void)setMerchandise:(Merchandise *)merchandise
{
    _merchandise = merchandise;
    if (_merchandise == nil) {
        merchandisePoints.text = @"";
        merchandisePrice.text = @"";
        merchandiseImage.image = DEFAULT_IMAGES;

    }else{
        NSString *displayedImageUrl = [merchandise.imageUrls objectAtIndex:0];
        [merchandiseImage setImageWithURL:[NSURL URLWithString:displayedImageUrl] placeholderImage:DEFAULT_IMAGES];
        
        NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] init];
        [priceString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f", _merchandise.price] attributes:@{ NSForegroundColorAttributeName : [UIColor appLightBlue], NSFontAttributeName :  [UIFont systemFontOfSize:14.f] }]];

        merchandisePrice.attributedText = priceString;

        NSMutableAttributedString *pointsString = [[NSMutableAttributedString alloc] init];
        [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d米米", merchandise.points] attributes:@{ NSForegroundColorAttributeName : [UIColor appLightBlue], NSFontAttributeName :  [UIFont systemFontOfSize:14.f] }]];
        merchandisePoints.attributedText = pointsString;
    }
}

@end
