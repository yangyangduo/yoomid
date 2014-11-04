//
//  CashPaymentTypePicker.m
//  private_share
//
//  Created by Zhao yang on 9/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "CashPaymentTypePicker.h"
#import "UIColor+App.h"
//#import "PayOrderViewController.h"
//#import "AppDelegate.h"

@implementation CashPaymentTypePicker

@synthesize btnItemDelegate = _btnItemDelegate;
@synthesize scrollView = _scrollView_;

- (instancetype)initWithSize:(CGSize)size message:(NSString *)message buttonItems:(NSArray *)buttonItems{
    self = [super initWithSize:size];
    if(self) {
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 44)];
        titleView.backgroundColor = [UIColor appColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, titleView.bounds.size.width - 30, 40)];
        titleLabel.text = @"选择支付方式";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.textColor = [UIColor appLightBlue];
        [titleView addSubview:titleLabel];
        [self.contentView addSubview:titleView];
        
        _scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleView.bounds.size.height + 15, titleView.bounds.size.width, self.contentView.bounds.size.height - titleView.bounds.size.height - 30)];
        _scrollView_.alwaysBounceVertical = YES;
        
        _scrollView_.contentSize = CGSizeMake(_scrollView_.bounds.size.width, 0);
        _scrollView_.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_scrollView_];
        NSMutableAttributedString *contentMessage = [[NSMutableAttributedString alloc] initWithString:message attributes : @{ NSFontAttributeName : [UIFont systemFontOfSize:16.f] }];

        CGSize contentMessageSize = [contentMessage boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width - 30, 300) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width - 30, contentMessageSize.height)];
        contentLabel.attributedText = contentMessage;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubviewInScrollView:contentLabel];
        
        for(CategoryButtonItem *buttonItem in buttonItems) {
            buttonItem.delegate = self;
            [self addSubviewInScrollView:buttonItem];
        }
    }
    return self;
}

- (instancetype) initWithSize:(CGSize)size message:(NSString *)message title1:(NSString *)title1 title2:(NSString *)title2
{
    self = [super initWithSize:size];
    if(self) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 44)];
        titleView.backgroundColor = [UIColor appColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, titleView.bounds.size.width - 30, 40)];
        titleLabel.text = @"订单状态";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.textColor = [UIColor appLightBlue];
        [titleView addSubview:titleLabel];
        [self.contentView addSubview:titleView];
        
        _scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleView.bounds.size.height + 15, titleView.bounds.size.width, self.contentView.bounds.size.height - titleView.bounds.size.height - 30)];
        _scrollView_.alwaysBounceVertical = YES;
        
        _scrollView_.contentSize = CGSizeMake(_scrollView_.bounds.size.width, 0);
        _scrollView_.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_scrollView_];
        NSMutableAttributedString *contentMessage = [[NSMutableAttributedString alloc] initWithString:message attributes : @{ NSFontAttributeName : [UIFont systemFontOfSize:16.f] }];
        
        CGSize contentMessageSize = [contentMessage boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width - 30, 300) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width - 30, contentMessageSize.height)];
        contentLabel.attributedText = contentMessage;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubviewInScrollView:contentLabel];
        
        if (title1 != nil || title2 != nil) {
            UIImageView *leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(25, contentLabel.frame.origin.y + contentLabel.bounds.size.height+10, 80, 43)];
            leftView1.image = [[UIImage imageNamed:@"categoryLeft"] stretchableImageWithLeftCapWidth:30 topCapHeight:5];
            [_scrollView_ addSubview:leftView1];
            UILabel *loginameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, leftView1.bounds.size.width, leftView1.bounds.size.height)];
            loginameLabel.textAlignment = NSTextAlignmentCenter;
            loginameLabel.textColor = [UIColor whiteColor];
            loginameLabel.text = @"物流公司";
            [leftView1 addSubview:loginameLabel];
            
            UIImageView *rightView1 = [[UIImageView alloc] initWithFrame:CGRectMake(leftView1.frame.origin.x + leftView1.bounds.size.width, leftView1.frame.origin.y, 120, 43)];
            rightView1.image = [[UIImage imageNamed:@"categoryRight"] stretchableImageWithLeftCapWidth:30 topCapHeight:5];
            [_scrollView_ addSubview:rightView1];
            UILabel *loginameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightView1.bounds.size.width, rightView1.bounds.size.height)];
            loginameLabel1.textAlignment = NSTextAlignmentCenter;
            loginameLabel1.textColor = [UIColor whiteColor];
            loginameLabel1.text = title1;
            [rightView1 addSubview:loginameLabel1];

            UIImageView *leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(25, rightView1.frame.origin.y + rightView1.bounds.size.height+10, 80, 43)];
            leftView2.image = [[UIImage imageNamed:@"categoryLeft"] stretchableImageWithLeftCapWidth:30 topCapHeight:5];
            [_scrollView_ addSubview:leftView2];
            UILabel *sendnoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, leftView2.bounds.size.width, leftView2.bounds.size.height)];
            sendnoLabel.textAlignment = NSTextAlignmentCenter;
            sendnoLabel.textColor = [UIColor whiteColor];
            sendnoLabel.text = @"物流单号";
            [leftView2 addSubview:sendnoLabel];

            UIImageView *rightView2 = [[UIImageView alloc] initWithFrame:CGRectMake(leftView2.frame.origin.x + leftView2.bounds.size.width, leftView2.frame.origin.y, 120, 43)];
            rightView2.image = [[UIImage imageNamed:@"categoryRight"] stretchableImageWithLeftCapWidth:30 topCapHeight:5];
            [_scrollView_ addSubview:rightView2];
            UILabel *sendnoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightView2.bounds.size.width, rightView2.bounds.size.height)];
            sendnoLabel1.textAlignment = NSTextAlignmentLeft;
            sendnoLabel1.numberOfLines = 2;
            sendnoLabel1.textColor = [UIColor whiteColor];
            sendnoLabel1.text = title2;
            [rightView2 addSubview:sendnoLabel1];
        }
    }
    return self;
}

- (void)addSubviewInScrollView:(UIView *)view {
    CGFloat y = _scrollView_.contentSize.height + 15;
    if(y == 15) y = 0;
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
    view.center = CGPointMake(_scrollView_.center.x, view.center.y);
    
    [_scrollView_ addSubview:view];
    _scrollView_.contentSize = CGSizeMake(_scrollView_.bounds.size.width, y + view.bounds.size.height);
}
//点击按钮 代理
- (void)categoryButtonItemDidSelectedWithIdentifier:(NSString *)identifier {
    [self closeViewAnimated:YES completion:^{
//        PayOrderViewController *payOrderVC = nil;
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [[app topViewController].navigationController pushViewController:[[PayOrderViewController alloc] init] animated:YES];
        if(self.btnItemDelegate != nil && [self.btnItemDelegate respondsToSelector:@selector(categoryButtonItemDidSelectedWithIdentifier:)]) {
            [self.btnItemDelegate categoryButtonItemDidSelectedWithIdentifier:identifier];
        }
    }];
}

@end
