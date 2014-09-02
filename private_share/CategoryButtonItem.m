//
//  CategoryButtonItem.m
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CategoryButtonItem.h"

@implementation CategoryButtonItem {
    NSString *_identifier_;
}

@synthesize delegate = _delegate_;

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title imageName:(NSString *)imageName {
    self = [super initWithFrame:CGRectMake(0, 0, 219, 40)];
    if(self) {
        _identifier_ = identifier;
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 49, 43)];
        iconView.image = [[UIImage imageNamed:@"categoryLeft"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
        [self addSubview:iconView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(iconView.bounds.size.width, 0, 170, 43)];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[[UIImage imageNamed:@"categoryRight"] stretchableImageWithLeftCapWidth:10 topCapHeight:5] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}

- (void)buttonPressed:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(categoryButtonItemDidSelectedWithIdentifier:)]) {
        [self.delegate categoryButtonItemDidSelectedWithIdentifier:_identifier_];
    }
}

@end
