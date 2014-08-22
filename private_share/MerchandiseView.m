//
//  MerchandiseView.m
//  private_share
//
//  Created by Zhao yang on 7/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseView.h"
#import "ProgressView.h"
#import "Account.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MerchandiseView {
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *pointsLabel;
    UILabel *percentLabel;
    ProgressView *progressView;
}

@synthesize merchandise = _merchandise_;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 90, 80)];
        [self addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.bounds.size.height, self.bounds.size.width, 26)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.text = @"";
        [self addSubview:titleLabel];
        
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.bounds.size.height - 5, self.bounds.size.width, 20)];
        pointsLabel.textAlignment = NSTextAlignmentCenter;
        pointsLabel.font = [UIFont systemFontOfSize:10.f];
        pointsLabel.textColor = [UIColor lightGrayColor];
        pointsLabel.text = @"";
        [self addSubview:pointsLabel];
        
        progressView = [[ProgressView alloc] initWithFrame:CGRectMake(5, pointsLabel.frame.origin.y + pointsLabel.bounds.size.height, 90, 5)];
        progressView.backgroundView.backgroundColor = [UIColor colorWithRed:141.f / 255.f green:168.f / 255.f blue:184.f / 255.f alpha:1.0f];
        progressView.trackView.backgroundColor = [UIColor colorWithRed:0 / 255.f green:159.f / 255.f blue:224.f / 255.f alpha:1.0f];
        progressView.layer.cornerRadius = 2;
        [self addSubview:progressView];
        
        percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, progressView.frame.origin.y + progressView.bounds.size.height, 90, 20)];
        percentLabel.text = @"";
        percentLabel.textAlignment = NSTextAlignmentRight;
        percentLabel.font = [UIFont systemFontOfSize:10.f];
        percentLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:percentLabel];
        
        UIView *tapView = [[UIView alloc] initWithFrame:self.bounds];
        tapView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tapView addGestureRecognizer:tapGesture];
        [self addSubview:tapView];
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if(self.merchandise != nil) {
    }
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
    if(_merchandise_ == nil) {
        titleLabel.text = @"";
        pointsLabel.text = @"";
        imageView.image = nil;
    } else {
        [imageView setImageWithURL:[NSURL URLWithString:_merchandise_.firstImageUrl] placeholderImage:nil];
        titleLabel.text = _merchandise_.name == nil ? @"" : _merchandise_.name;
        pointsLabel.text = [NSString stringWithFormat:@"(P: %ld)", (long)_merchandise_.points];
        float progress = 1.0f;
        if(merchandise.points != 0) {
            progress = (float)[Account currentAccount].points / (float)merchandise.points;
        }
        if(progress > 1.f) {
            progress = 1.f;
        }
        [progressView setProgress:progress];
        percentLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    }
}

@end
