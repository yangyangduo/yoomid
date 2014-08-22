//
//  ActivityCollectionViewCell.m
//  private_share
//
//  Created by Zhao yang on 6/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ActivityCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+Color.h"
#import "UIColor+App.h"

@interface NoActionButton : UIButton

@end

@implementation NoActionButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

@end

@implementation ActivityCollectionViewCell {
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *thinksGoodLabel;
    UILabel *dateTimeLabel;
    
    Merchandise *_merchandise_;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        UIImageView *topMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 55)];
        topMaskImageView.image = [UIImage imageNamed:@"black_top"];
        topMaskImageView.userInteractionEnabled = YES;
        [imageView addSubview:topMaskImageView];
        
        UIButton *exellentButton = [[UIButton alloc] initWithFrame:CGRectMake(245, 10, 19.f, 19.f)];
        [exellentButton setImage:[UIImage imageNamed:@"exellent"] forState:UIControlStateNormal];
        [exellentButton addTarget:self action:@selector(exellentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topMaskImageView addSubview:exellentButton];
        
        thinksGoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 5, 50, 30)];
        thinksGoodLabel.text = [NSString stringWithFormat:@"%ld", 0L];
        thinksGoodLabel.font = [UIFont systemFontOfSize:15.f];
        thinksGoodLabel.textAlignment = NSTextAlignmentCenter;
        thinksGoodLabel.backgroundColor = [UIColor clearColor];
        thinksGoodLabel.textColor = [UIColor whiteColor];
        [topMaskImageView addSubview:thinksGoodLabel];
        
        UIImageView *bottomMaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 84, self.bounds.size.width, 84)];
        bottomMaskImageView.image = [UIImage imageNamed:@"black_bottom"];
        [imageView addSubview:bottomMaskImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, self.bounds.size.width - 20, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:240.f / 255.f green:240.f / 255.f blue:240.f / 255.f alpha:1.0f];
        titleLabel.font = [UIFont systemFontOfSize:13.f];
        
        dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, self.bounds.size.width - 20, 22)];
        dateTimeLabel.backgroundColor = [UIColor clearColor];
        dateTimeLabel.textColor = [UIColor colorWithRed:240.f / 255.f green:240.f / 255.f blue:240.f / 255.f alpha:1.0f];
        dateTimeLabel.font = [UIFont systemFontOfSize:10.f];
        dateTimeLabel.text = @"";
        [bottomMaskImageView addSubview:dateTimeLabel];
        [bottomMaskImageView addSubview:titleLabel];
        
        UIButton *button = [[NoActionButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 65, self.bounds.size.height - 40, 54, 22)];
        [button setTitle:NSLocalizedString(@"i_want_to_grab", @"") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.f;
//       UIImage *backgroundImage = [UIImage imageWithColor:[UIColor appDarkOrange] size:CGSizeMake(80, 28)];
//        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor appColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:button];
    }
    return self;
}

- (void)setMerchandise:(Merchandise *)merchandise {
    _merchandise_ = merchandise;
    [imageView setImageWithURL:[NSURL URLWithString:merchandise.firstImageUrl] placeholderImage:nil];
    titleLabel.text = merchandise.name;
    thinksGoodLabel.text = [NSString stringWithFormat:@"%ld", merchandise.follows];
    
    NSDate *now = [NSDate date];
    NSTimeInterval nowTimeInterval = now.timeIntervalSince1970 * 1000;
    if(nowTimeInterval < merchandise.buyStartTime.timeIntervalSince1970 * 1000) {
        dateTimeLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"from_beginning_of_activity_start", @""), [self displayedTime:merchandise.buyStartTime.timeIntervalSince1970 * 1000 - nowTimeInterval]];
    } else if(nowTimeInterval >= merchandise.buyStartTime.timeIntervalSince1970 * 1000
              && nowTimeInterval < merchandise.buyEndTime.timeIntervalSince1970 * 1000) {
        dateTimeLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"from_beginning_of_activity_end", @""), [self displayedTime:merchandise.buyEndTime.timeIntervalSince1970 * 1000 - nowTimeInterval]];
    } else {
        dateTimeLabel.text = NSLocalizedString(@"activity_ended", @"");
    }
}

- (void)exellentButtonPressed:(id)sender {
    if(_merchandise_ == nil) return;
    NSLog(@"%@", _merchandise_.name);
}

- (NSString *)displayedTime:(NSTimeInterval)timeInterval {
    double days = floor(timeInterval / (1000 * 60 * 60 * 24));
    timeInterval -= days * 24 * 60 * 60 * 1000;
    double hours = floor((timeInterval / (1000 * 60 * 60)));
    timeInterval -= hours * 60 * 60 * 1000;
    double minutes = floor(timeInterval / (1000 * 60));
    return [NSString stringWithFormat:@"%.0f天 %.0f小时 %.0f分", days, hours, minutes];
}

@end
