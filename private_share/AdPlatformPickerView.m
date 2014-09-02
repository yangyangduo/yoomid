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
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 44)];
        titleView.backgroundColor = [UIColor appColor];
        [self.contentView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, titleView.bounds.size.width - 30, 40)];
        titleLabel.text = @"安装应用获得丰厚奖励";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.textColor = [UIColor appLightBlue];
        [titleView addSubview:titleLabel];
        
        NSMutableAttributedString *contentMessage = [[NSMutableAttributedString alloc] initWithString:@"请按应用要求安装并试玩一段时间后(部分要求注册),返回有米得即可领取米米。部分时间由于网络延迟,米米不能立即到账,请耐心等待。注意:相同的应用只能领取一次奖励,且再接受任务前已安装的应用不能领取米米。" attributes : @{ NSFontAttributeName : [UIFont systemFontOfSize:16.f] }];
        [contentMessage addAttribute:NSForegroundColorAttributeName value:[UIColor appLightBlue] range:NSMakeRange(66, 13)];
        CGSize contentMessageSize = [contentMessage boundingRectWithSize:CGSizeMake(titleLabel.bounds.size.width, 300) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.bounds.size.height + 20, titleLabel.bounds.size.width, contentMessageSize.height)];
        contentLabel.attributedText = contentMessage;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:contentLabel];
    }
    return self;
}


@end
