//
//  MerchandisesOrderFooterView.m
//  private_share
//
//  Created by 曹大为 on 14/11/4.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "MerchandisesOrderFooterView.h"
#import "UIColor+App.h"

@implementation MerchandisesOrderFooterView
{
    UILabel *summariesLabel;
    UILabel *postageLabel;
    UILabel *totalLabel;
    UILabel *pointLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        summariesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 15)];
        summariesLabel.backgroundColor = [UIColor clearColor];
        summariesLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:summariesLabel];
        
        postageLabel = [[UILabel alloc] initWithFrame:CGRectMake(summariesLabel.frame.origin.x + summariesLabel.bounds.size.width+55, 0, 80, 15)];
        postageLabel.backgroundColor = [UIColor clearColor];
        postageLabel.font = [UIFont systemFontOfSize:13.f];
//        postageLabel.text = @"游资: 5.0";
        [self addSubview:postageLabel];
        
        totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(postageLabel.frame.origin.x + postageLabel.bounds.size.width, 0, 120, 15)];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.font = [UIFont systemFontOfSize:13.f];
//        totalLabel.text = @"合计: 5.0";
        [self addSubview:totalLabel];

        pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x, 24, 120, 15)];
        pointLabel.backgroundColor = [UIColor clearColor];
        pointLabel.font = [UIFont systemFontOfSize:13.f];
//        pointLabel.text = @"米米抵现金";
        [self addSubview:pointLabel];
    }
    return self;
}

- (void)setMerchandiseOrder:(MerchandiseOrder *)merchandiseOrder
{
    if (merchandiseOrder == nil) {
        summariesLabel.text = @"";
        postageLabel.text = @"";
        totalLabel.text = @"";
        pointLabel.text = @"";
    }else{
        summariesLabel.text = [NSString stringWithFormat:@"共%d件商品",merchandiseOrder.merchandiseLists.count];
        NSMutableAttributedString *attributePostageString = [[NSMutableAttributedString alloc] initWithString:@"邮: " attributes:
                                                             @{
                                                               NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                                               NSForegroundColorAttributeName :  [UIColor blackColor] }];
        [attributePostageString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ 5.0"] attributes:
                                           @{
                                             NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                             NSForegroundColorAttributeName :  [UIColor appLightBlue] }]];
        
        postageLabel.attributedText = attributePostageString;
        
        NSMutableAttributedString *attributeTotalString = [[NSMutableAttributedString alloc] initWithString:@"合计: " attributes:
                                                             @{
                                                               NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                                               NSForegroundColorAttributeName :  [UIColor blackColor] }];
        [attributeTotalString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",merchandiseOrder.totalCash] attributes:
                                                        @{
                                                          NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                                          NSForegroundColorAttributeName :  [UIColor appLightBlue] }]];
        totalLabel.attributedText = attributeTotalString;
        
        if (merchandiseOrder.totalPoints > 0.0f) {
            NSMutableAttributedString *attributePointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d ",merchandiseOrder.totalPoints] attributes:
                                                               @{
                                                                 NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                                                 NSForegroundColorAttributeName :  [UIColor appLightBlue] }];
            [attributePointString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"米米抵现" attributes:
                                                          @{
                                                            NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                                            NSForegroundColorAttributeName :  [UIColor blackColor] }]];
            pointLabel.attributedText = attributePointString;

            pointLabel.hidden = NO;
        }else
        {
            pointLabel.hidden = YES;
        }

    }
}
@end
