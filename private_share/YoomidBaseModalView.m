//
//  YoomidBaseModalView.m
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "YoomidBaseModalView.h"

@implementation YoomidBaseModalView {
}

@synthesize contentView = _contentView_;

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        
        _contentView_ = [[UIView alloc] initWithFrame:CGRectMake(14, 14, size.width - 28, size.height - 28)];
        [self addSubview:_contentView_];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:_contentView_.bounds];
        UIImage *backgroundImage = [[UIImage imageNamed:@"modal_background"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        backgroundImageView.image = backgroundImage;
        [_contentView_ addSubview:backgroundImageView];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(_contentView_.frame.origin.x + _contentView_.bounds.size.width - 18, 4, 56.f / 2, 56.f / 2)];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"modal_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeviewInternal) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        _contentView_.layer.cornerRadius = 10;
        _contentView_.layer.masksToBounds = YES;
    }
    return self;
}

- (void)closeviewInternal {
    [self closeViewAnimated:YES completion:nil];
}

- (UIView *)contentView {
    return _contentView_;
}

@end
