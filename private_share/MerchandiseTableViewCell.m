//
//  MerchandiseTableViewCell.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseTableViewCell.h"
#import "UIColor+App.h"
#import "ProgressView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Account.h"

#define DEFAULT_IMAGE [UIImage imageNamed:@"merchandise_placeholder"]

@implementation MerchandiseTableViewCell {
    UIImageView *imageView;
    ProgressView *progressView;
    UILabel *progressLabel;
    
    UILabel *titleLabel;
    UILabel *pointsLabel;
    UILabel *messageLabel;
}

@synthesize merchandise = _merchandise_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 120, 90)];
        imageView.image = DEFAULT_IMAGE;
        [self addSubview:imageView];
        
        progressView = [[ProgressView alloc] initWithFrame:CGRectMake(13, 115, 90, 7)];
        progressView.backgroundView.backgroundColor = [UIColor colorWithRed:141.f / 255.f green:168.f / 255.f blue:184.f / 255.f alpha:1.0f];
        progressView.trackView.backgroundColor = [UIColor appColor];
        progressView.layer.cornerRadius = 5;
        [self addSubview:progressView];
        
        progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressView.bounds.size.width + progressView.frame.origin.x, 0, 37, 22)];
        progressLabel.text = @"";
        progressLabel.textColor = [UIColor lightGrayColor];
        progressLabel.font = [UIFont systemFontOfSize:11.f];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.center = CGPointMake(progressLabel.center.x, progressView.center.y);
        [self addSubview:progressLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(146, 6, 155, 48)];
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"";
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(146, 56, 125, 36)];
        pointsLabel.font = [UIFont systemFontOfSize:20.f];
        pointsLabel.textColor = [UIColor appColor];
        pointsLabel.backgroundColor = [UIColor clearColor];
        pointsLabel.text = @"";
        [self addSubview:pointsLabel];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(146, 95, 150, 34)];
        messageLabel.font = [UIFont systemFontOfSize:14.f];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.text = @"";
        [self addSubview:messageLabel];
        
        UIImageView *cartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 85, 56 / 2, 55.f / 2)];
        cartImageView.image = [UIImage imageNamed:@"icon_blue_cart"];
        [self addSubview:cartImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMerchandise:(Merchandise *)merchandise {
    if(merchandise == nil) {
        titleLabel.text = @"";
        pointsLabel.text = @"";
        messageLabel.text = @"";
        imageView.image = DEFAULT_IMAGE;
    } else {
        if(merchandise.imageUrls == nil || merchandise.imageUrls.count == 0) {
            imageView.image = DEFAULT_IMAGE;
        } else {
            NSString *displayedImageUrl = [merchandise.imageUrls objectAtIndex:0];
            [imageView setImageWithURL:[NSURL URLWithString:displayedImageUrl] placeholderImage:DEFAULT_IMAGE];
        }
        titleLabel.text = merchandise.name;
        
        NSMutableAttributedString *pointsString = [[NSMutableAttributedString alloc] init];
        [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ", (long)merchandise.points] attributes:@{ NSForegroundColorAttributeName : [UIColor appColor], NSFontAttributeName :  [UIFont systemFontOfSize:27.f] }]];
        [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:@"P" attributes:@{ NSForegroundColorAttributeName : [UIColor appColor], NSFontAttributeName :  [UIFont systemFontOfSize:18.f] }]];
        pointsLabel.attributedText = pointsString;
        
        messageLabel.text = [NSString stringWithFormat:@"%ld%@!", (long)merchandise.exchangeCount, NSLocalizedString(@"has_exchanges", @"")];
        
        float progress = 1.f;
        if(merchandise.points != 0) {
            progress = ((float)[Account currentAccount].points / (float)merchandise.points);
        }
        if(progress > 1.f) {
            progress = 1;
        }
        [progressView setProgress:progress];
        progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    }
    _merchandise_ = merchandise;
}

@end
