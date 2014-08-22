//
//  OrderFooterView.m
//  private_share
//
//  Created by Zhao yang on 6/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "OrderFooterView.h"
#import "UIColor+App.h"
#import "ViewQRCodeViewController.h"

@implementation OrderFooterView {
    UILabel *pointsTitleLabel;
    UILabel *cashTitleLabel;
    
    UILabel *pointsLabel;
    UILabel *cashLabel;
    
    NSString *_order_id_;
}

@synthesize containerViewController;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 12, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        UIView *spacingView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 15, frame.size.width, 15)];
        spacingView.backgroundColor = [UIColor appSilver];
        [self addSubview:spacingView];
        
        UIButton *viewQrCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(230, spacingView.frame.origin.y - 35, 80, 25)];
        viewQrCodeButton.layer.borderWidth = .5f;
        viewQrCodeButton.layer.borderColor = [UIColor grayColor].CGColor;
        viewQrCodeButton.layer.cornerRadius = 6;
        viewQrCodeButton.titleLabel.textColor = [UIColor lightGrayColor];
        [viewQrCodeButton setTitle:NSLocalizedString(@"view_qr_code", @"") forState:UIControlStateNormal];
        [viewQrCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        viewQrCodeButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [viewQrCodeButton addTarget:self action:@selector(viewQrCodeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewQrCodeButton];
        
        pointsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 40, 18)];
        pointsTitleLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"points", @"")] ;
        pointsTitleLabel.font = [UIFont systemFontOfSize:10.f];
        pointsTitleLabel.textColor = [UIColor lightGrayColor];
        
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 17, 150, 18)];
        pointsLabel.text = @"";
        pointsLabel.font = [UIFont systemFontOfSize:10.f];
        pointsLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:pointsTitleLabel];
        [self addSubview:pointsLabel];
        
        cashTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 40, 18)];
        cashTitleLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"cash", @"")] ;
        cashTitleLabel.font = [UIFont systemFontOfSize:10.f];
        cashTitleLabel.font = [UIFont systemFontOfSize:10.f];
        cashTitleLabel.textColor = [UIColor lightGrayColor];
        
        cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 31, 150, 18)];
        cashLabel.text = @"";
        cashLabel.font = [UIFont systemFontOfSize:10.f];
        cashLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:cashTitleLabel];
        [self addSubview:cashLabel];
    }
    return self;
}

- (void)setTotalPoints:(NSInteger)totalPoints totalCash:(float)totalCash orderId:(NSString *)orderId {
    if(pointsLabel) {
        pointsLabel.text = [NSString stringWithFormat:@"%ld %@", (long)totalPoints, NSLocalizedString(@"points_short_name", @"")];
    }
    if(cashLabel) {
        cashLabel.text = [NSString stringWithFormat:@"%.1f %@", totalCash, NSLocalizedString(@"yuan", @"")];
    }
    _order_id_ = orderId;
}

- (void)viewQrCodeButtonPressed:(id)sender {
    if(_order_id_ == nil) return;
    if(self.containerViewController != nil) {
        [self.containerViewController.navigationController pushViewController:[[ViewQRCodeViewController alloc] initWithOrderId:_order_id_] animated:YES];
    }
}

@end
