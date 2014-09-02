//
//  AdPlatformPickerView.m
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AdPlatformPickerView.h"
#import "UIColor+App.h"

@implementation AdPlatformPickerView {

}

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        NSMutableAttributedString *contentMessage = [[NSMutableAttributedString alloc] initWithString:@"请按应用要求安装并试玩一段时间后(部分要求注册),返回有米得即可领取米米。部分时间由于网络延迟,米米不能立即到账,请耐心等待。注意:相同的应用只能领取一次奖励,且再接受任务前已安装的应用不能领取米米。" attributes : @{ NSFontAttributeName : [UIFont systemFontOfSize:16.f] }];
        [contentMessage addAttribute:NSForegroundColorAttributeName value:[UIColor appLightBlue] range:NSMakeRange(66, 13)];
        CGSize contentMessageSize = [contentMessage boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width - 30, 300) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.contentView.bounds.size.width - 30, contentMessageSize.height)];
        contentLabel.attributedText = contentMessage;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubviewInScrollView:contentLabel];
    }
    return self;
}

- (void)f {
    /*
    
    if(indexPath.row == 0) {
        [YouMiWall showOffers:YES didShowBlock:^{
        } didDismissBlock:^{
        }];
    } else if(indexPath.row == 1) {
        if(domobOfferWall == nil) {
            domobOfferWall = [[DMOfferWallManager alloc] initWithPublisherID:kDomobSecretKey andUserID:[SecurityConfig defaultConfig].userName];
            domobOfferWall.disableStoreKit = YES;
        }
        [domobOfferWall presentOfferWallWithType:eDMOfferWallTypeList];
    }
     
     an wo
     */
}


@end
