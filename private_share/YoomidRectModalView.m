//
//  YoomidRectModalView.m
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidRectModalView.h"
#import "UIColor+App.h"

@implementation YoomidRectModalView

- (instancetype)initWithSize:(CGSize)size image:(UIImage *)image message:(NSString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex {
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
        
        if(buttonTitles != nil && buttonTitles.count > 0) {
            for(int i=0; i<buttonTitles.count; i++) {
                UIButton *button = nil;
                if(buttonTitles.count == 1) {
                    button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 142, 40)];
                    button.center = CGPointMake(centerX, button.center.y);
                } else {
                    button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 96, 40)];
                    button.center = CGPointMake(centerX + (i == 0 ? -55 : 55), button.center.y);
                }
                [button setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
                button.titleEdgeInsets = UIEdgeInsetsMake(9, 0, 0, 0);
                if(cancelButtonIndex == i) {
                    [button addTarget:self action:@selector(closeViewInternal) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [button addTarget:self action:@selector(OKbtn) forControlEvents:UIControlEventTouchUpInside];
                }
                [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [self addSubview:button];
            }
        }
    }
    return self;
}

- (void)closeViewInternal {
    [self closeViewAnimated:YES completion:^{
        if (self.shareDeletage != nil && [self.shareDeletage respondsToSelector:@selector(showShare)]) {
            [self.shareDeletage showShare];
        }
    }];
}

- (void)OKbtn{
    [self closeViewAnimated:YES completion:^{
        if (self.yoomidDelegate != nil && [self.yoomidDelegate respondsToSelector:@selector(OKbtn)]) {
            [self.yoomidDelegate OKbtn];
        }
    }];
}

@end
