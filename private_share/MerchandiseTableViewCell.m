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
    UILabel *rmbLabel;
    UILabel *messageLabel;
    
    UIImageView *bao;
    UIImageView *rmb ;
}

@synthesize merchandise = _merchandise_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bootomView = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 320-20, 143-15)];
        bootomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bootomView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 14.f, 100, 100)];
        imageView.image = DEFAULT_IMAGE;
        [bootomView addSubview:imageView];
        
        /*
        progressView = [[ProgressView alloc] initWithFrame:CGRectMake(13, 106, 75, 7)];
        progressView.backgroundView.backgroundColor = [UIColor colorWithRed:208.f / 255.f green:209.f / 255.f blue:211.f / 255.f alpha:1.f];// 162,226
        progressView.trackView.backgroundColor = [UIColor appLightBlue];
        progressView.layer.cornerRadius = 5;
        [bootomView addSubview:progressView];
        
        progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressView.bounds.size.width + progressView.frame.origin.x, 0, 37, 22)];
        progressLabel.text = @"";
        progressLabel.textColor = [UIColor lightGrayColor];
        progressLabel.font = [UIFont systemFontOfSize:11.f];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.center = CGPointMake(progressLabel.center.x, progressView.center.y);
//        [bootomView addSubview:progressLabel];
         */
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 13, 152, 45)];
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"";
        titleLabel.textColor = [UIColor blackColor];
        [bootomView addSubview:titleLabel];
        
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(125 + 20, titleLabel.frame.origin.y + titleLabel.bounds.size.height-18, 125, 36)];
        pointsLabel.font = [UIFont systemFontOfSize:20.f];
        pointsLabel.textColor = [UIColor appColor];
        pointsLabel.backgroundColor = [UIColor clearColor];
        pointsLabel.text = @"";
        [bootomView addSubview:pointsLabel];
        
        bao = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"points_blue"]];
        bao.frame = CGRectMake(125, pointsLabel.frame.origin.y+10, 32/2, 32/2);
        [bootomView addSubview:bao];
        
        rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(125+20, pointsLabel.frame.origin.y + pointsLabel.bounds.size.height-18, 125, 36)];
        rmbLabel.font = [UIFont systemFontOfSize:20.f];
        rmbLabel.textColor = [UIColor appColor];
        rmbLabel.backgroundColor = [UIColor clearColor];
        [bootomView addSubview:rmbLabel];
        
        rmb = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rmb_blue"]];
        rmb.frame = CGRectMake(125, rmbLabel.frame.origin.y+10, 32/2, 32/2);
        [bootomView addSubview:rmb];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 91, 100, 34)];
        messageLabel.font = [UIFont systemFontOfSize:14.f];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.text = @"";
        [bootomView addSubview:messageLabel];
        
        UIImageView *cartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(245, 88, 51 / 2, 51.f / 2)];
        cartImageView.image = [UIImage imageNamed:@"shopping"];
        [bootomView addSubview:cartImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMerchandise:(Merchandise *)merchandise {
    if(merchandise == nil)
    {
        titleLabel.text = @"";
        pointsLabel.text = @"";
        rmbLabel.text = @"";
        messageLabel.text = @"";
        rmbLabel.text = @"";
        imageView.image = DEFAULT_IMAGE;
    } else {
        if(merchandise.imageUrls == nil || merchandise.imageUrls.count == 0) {
            imageView.image = DEFAULT_IMAGE;
        } else {
            NSString *displayedImageUrl = [merchandise.imageUrls objectAtIndex:0];
            [imageView setImageWithURL:[NSURL URLWithString:displayedImageUrl] placeholderImage:DEFAULT_IMAGE];
        }
        titleLabel.text = merchandise.name;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.f]};
        CGSize titleLabelSize = [merchandise.name boundingRectWithSize:CGSizeMake(145, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        titleLabel.frame = CGRectMake(125, 13, titleLabelSize.width, titleLabelSize.height);
        
        NSMutableAttributedString *pointsString = [[NSMutableAttributedString alloc] init];
        [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ", (long)merchandise.points] attributes:@{ NSForegroundColorAttributeName : [UIColor appLightBlue], NSFontAttributeName :  [UIFont systemFontOfSize:18.f] }]];
        
        [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"points", @"") attributes:@{ NSForegroundColorAttributeName : [UIColor appColor], NSFontAttributeName :  [UIFont systemFontOfSize:12.f] }]];
        pointsLabel.attributedText = pointsString;
        //(titleLabel.frame.origin.y+titleLabelSize.height)
        pointsLabel.frame = CGRectMake(125+20, 45, 125, 36);
        bao.frame = CGRectMake(125, pointsLabel.frame.origin.y + 10,32/2, 32/2);
        
        NSMutableAttributedString *rmbString = [[NSMutableAttributedString alloc] init];
        [rmbString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f", (float)merchandise.points / 100.f] attributes:@{ NSForegroundColorAttributeName : [UIColor appLightBlue], NSFontAttributeName :  [UIFont systemFontOfSize:18.f] }]];
        
        [rmbString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"yuan", @"") attributes:@{ NSForegroundColorAttributeName : [UIColor appColor], NSFontAttributeName :  [UIFont systemFontOfSize:12.f] }]];
        rmbLabel.attributedText = rmbString;
        rmbLabel.frame = CGRectMake(125+20,pointsLabel.frame.origin.y + 22, 125, 36);
        rmb.frame = CGRectMake(125, rmbLabel.frame.origin.y + 10, 32/2, 32/2);

        messageLabel.text = [NSString stringWithFormat:@"%ld%@!", (long)merchandise.exchangeCount, NSLocalizedString(@"has_exchanges", @"")];
        /*
        float progress = 1.f;
        if(merchandise.points != 0) {
            progress = ((float)[Account currentAccount].points / (float)merchandise.points);
        }
        if(progress > 1.f) {
            progress = 1;
        }
//        [progressView setProgress:progress];
//        progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
         */
    }
    _merchandise_ = merchandise;
}

@end
