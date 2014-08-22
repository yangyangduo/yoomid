//
//  ActivityMerchandiseTableViewCell.m
//  private_share
//
//  Created by Zhao yang on 6/7/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ActivityMerchandiseTableViewCell.h"
#import "UIColor+App.h"

#define DEFAULT_IMAGE [UIImage imageNamed:@"merchandise_placeholder"]

@implementation ActivityMerchandiseTableViewCell {
    UIImageView *imageView;

    UILabel *titleLabel;
    UILabel *descriptionLabel;
    UILabel *pointsLabel;
    UILabel *messageLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 140, 120)];
        imageView.image = DEFAULT_IMAGE;
        [self addSubview:imageView];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 30, 160, 44)];
        descriptionLabel.font = [UIFont systemFontOfSize:14.f];
        descriptionLabel.textColor = [UIColor lightGrayColor];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.text = @"和红色大剧院,和父母一起看\"魔幻音乐剧\"!";
        [self addSubview:descriptionLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 1, 160, 34)];
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"童心同乐庆祝六一";
        [self addSubview:titleLabel];
        
//        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 62, 100, 24)];
//        pointsLabel.font = [UIFont systemFontOfSize:16.f];
//        pointsLabel.textColor = [UIColor orangeColor];
//        pointsLabel.backgroundColor = [UIColor clearColor];
//        pointsLabel.text = @"aaa";
//        [self addSubview:pointsLabel];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 82, 150, 34)];
        messageLabel.font = [UIFont systemFontOfSize:14.f];
        messageLabel.textColor = [UIColor appColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.text = @"20积分";
        [self addSubview:messageLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
