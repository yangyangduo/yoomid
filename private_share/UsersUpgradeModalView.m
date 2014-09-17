//
//  UsersUpgradeModalView.m
//  private_share
//
//  Created by 曹大为 on 14-9-17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UsersUpgradeModalView.h"
#import "UIColor+App.h"

@implementation UsersUpgradeModalView

- (instancetype) initWithSize:(CGSize)size 
{
    self = [super initWithSize:size];
    if(self) {
    }
    return self;
}

- (instancetype) initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message
{
    self = [super initWithSize:size];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500/2, 761/2)];
        bgImageView.image = [UIImage imageNamed:@"bg6"];
        [self addSubview:bgImageView];
        
        CGFloat centerX = size.width / 2.f;
        CGFloat y = 170.f;
        
        if (titleMessage) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 250, 30)];
            titleLabel.font = [UIFont systemFontOfSize:20];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
            titleLabel.textColor = [UIColor appLightBlue];
            titleLabel.text = titleMessage;
            [self addSubview:titleLabel];
            
            y += titleLabel.bounds.size.height + 10.f;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 220, 1)];
        lineView.center = CGPointMake(centerX, lineView.center.y);
        lineView.backgroundColor = [UIColor colorWithRed:230.f / 255.f green:230.f / 255 blue:230.f / 255 alpha:1.0];
        [self addSubview:lineView];
        
        y += 15;
        
        if (message) {
            UIFont *messageFont = [UIFont systemFontOfSize:14.f];
            
            CGSize messageSize = [message boundingRectWithSize:CGSizeMake(size.width - 40, 100) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : messageFont } context:nil].size;
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, messageSize.width, messageSize.height)];
            messageLabel.font = messageFont;
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.center = CGPointMake(centerX, messageLabel.center.y);
            messageLabel.textColor = [UIColor appTextFieldGray];
            messageLabel.text = message;
            [self addSubview:messageLabel];
        }
        
        y += 15;
    }
    return self;
}

@end
