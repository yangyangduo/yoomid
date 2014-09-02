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
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(14, 14, size.width - 28, size.height - 28)];
        backgroundView.backgroundColor = [UIColor colorWithRed:219.f / 255.f green:220.f / 255.f blue:222.f / 255.f alpha:1.f];
        [self addSubview:backgroundView];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(backgroundView.frame.origin.x + backgroundView.bounds.size.width - 18, 4, 56.f / 2, 56.f / 2)];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"modal_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeviewInternal) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        backgroundView.layer.cornerRadius = 10;
        backgroundView.layer.masksToBounds = YES;
        
        _contentView_ = [[UIView alloc] initWithFrame:CGRectMake(3, 3, backgroundView.frame.size.width - 6, backgroundView.frame.size.height - 6)];
        _contentView_.backgroundColor = [UIColor whiteColor];
        _contentView_.layer.cornerRadius = 10;
        _contentView_.layer.masksToBounds = YES;
        [backgroundView addSubview:_contentView_];
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
