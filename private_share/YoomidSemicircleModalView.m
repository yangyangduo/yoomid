//
//  YoomidSemicircleModalView.m
//  private_share
//
//  Created by Zhao yang on 9/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidSemicircleModalView.h"
#import "UIColor+App.h"

@implementation YoomidSemicircleModalView

- (instancetype)initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex {
    self = [super initWithSize:size];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        
        if(backgroundImage) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
            backgroundImageView.image = backgroundImage;
            [self addSubview:backgroundImageView];
        }
        
        CGFloat centerX = size.width / 2.f;
        CGFloat y = 170.f;
        
        if(titleMessage) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, size.width, 30)];
            titleLabel.font = [UIFont systemFontOfSize:22];
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
        
        if(message) {
            UIFont *messageFont = [UIFont systemFontOfSize:18.f];
            
            CGSize messageSize = [message boundingRectWithSize:CGSizeMake(size.width - 40, 100) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : messageFont } context:nil].size;
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, messageSize.width, messageSize.height)];
            messageLabel.font = messageFont;
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.center = CGPointMake(centerX, messageLabel.center.y);
            messageLabel.textColor = [UIColor appLightBlue];
            messageLabel.text = message;
            [self addSubview:messageLabel];
            
            y += messageLabel.bounds.size.height + 20.f;
        }
        
        if(buttonTitles != nil && buttonTitles.count > 0) {
            for(int i=0; i<buttonTitles.count; i++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 90, 40)];
                button.center = CGPointMake(centerX, button.center.y);
                [button setBackgroundImage:[UIImage imageNamed:((i % 2 == 0) ? @"button_up" : @"button_down")] forState:UIControlStateNormal];
                if(i % 2 == 0) {
                    button.titleEdgeInsets = UIEdgeInsetsMake(9, 0, 0, 0);
                } else {
                    button.titleEdgeInsets = UIEdgeInsetsMake(-6, 2, 0, 0);
                }
                if(cancelButtonIndex == i) {
                    [button addTarget:self action:@selector(closeViewInternal) forControlEvents:UIControlEventTouchUpInside];
                }
                else if (i == 1)
                {
                    [button addTarget:self action:@selector(shwoShare) forControlEvents:UIControlEventTouchUpInside];
                }
                [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [self addSubview:button];
                y += button.bounds.size.height + 20;
            }
        }
    }
    return self;
}

- (void)shwoShare{
}

- (void)closeViewInternal {
    [self closeViewAnimated:YES completion:nil];
}

@end
