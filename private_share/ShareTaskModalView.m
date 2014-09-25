//
//  ShareTaskModalView.m
//  private_share
//
//  Created by 曹大为 on 14/9/25.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ShareTaskModalView.h"
#import "UIColor+App.h"

@implementation ShareTaskModalView

- (instancetype) initWithSize:(CGSize)size image:(UIImage *)image message:(NSString *)message
{
    self = [super initWithSize:size];
    if(self) {
        CGFloat centerX = size.width / 2.f;
        CGFloat y = 40.f;

        if(image) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.center = CGPointMake(centerX, 0);
            CGRect frame = imageView.frame;
            frame.origin.y = y;
            imageView.frame = frame;
            [self addSubview:imageView];
            y += imageView.bounds.size.height + 25.f;
        }
        
        if(message) {
            UIFont *messageFont = [UIFont systemFontOfSize:23.f];
            
            CGSize messageSize = [message boundingRectWithSize:CGSizeMake(size.width - 40, 100) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : messageFont } context:nil].size;
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, messageSize.width, messageSize.height)];
            messageLabel.font = messageFont;
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.center = CGPointMake(centerX, messageLabel.center.y);
            messageLabel.textColor = [UIColor appLightBlue];
            messageLabel.text = message;
            [self addSubview:messageLabel];
            
            y += messageLabel.bounds.size.height + 30.f;
        }

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 142, 40)];
        button.center = CGPointMake(centerX, button.center.y);
        [button setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(9, 0, 0, 0);
        [button addTarget:self action:@selector(actionShowShare) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"立刻分享" forState:UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}
- (void)actionShowShare
{
    [self closeViewAnimated:YES completion:^{
        if (self.shareDeletage != nil && [self.shareDeletage respondsToSelector:@selector(showShare)]) {
            [self.shareDeletage showShare];
        }
    }];
}
@end
