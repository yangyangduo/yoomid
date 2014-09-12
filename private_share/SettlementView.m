//
//  SettlementView.m
//  private_share
//
//  Created by Zhao yang on 7/21/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SettlementView.h"
#import "UIColor+App.h"
#import "UIImage+Color.h"
#import "ShoppingCart.h"

@implementation SettlementView {
    UIButton *selectButton;
    UILabel *summariesLabel;
    
    UIImageView *pointsPaymentImageView;
    UILabel *pointsPaymentLabel;
    
    UIImageView *cashPaymentImageView;
    UILabel *cashPaymentLabel;
    
    UIButton *rightButton;
    
    BOOL selectButtonHidden;
}

@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        
        selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 44, 44)];
        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateNormal];
//        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateHighlighted];
        [selectButton setImage:[UIImage imageNamed:@"cb_select"] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.selected = [ShoppingCart myShoppingCart].allSelect;
        [self addSubview:selectButton];
        
        summariesLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectButton.bounds.size.width, 8, 90, 44)];
        summariesLabel.text = @"全选     合计:";
        summariesLabel.backgroundColor = [UIColor clearColor];
        summariesLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:summariesLabel];
        
        pointsPaymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(summariesLabel.frame.origin.x + summariesLabel.frame.size.width + 8, 10, 16, 16)];
        pointsPaymentImageView.image = [UIImage imageNamed:@"points_blue"];
        [self addSubview:pointsPaymentImageView];
        
        pointsPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsPaymentImageView.frame.origin.x + pointsPaymentImageView.bounds.size.width + 5, pointsPaymentImageView.frame.origin.y - 2, 80, 20)];
        pointsPaymentLabel.backgroundColor = [UIColor clearColor];
        pointsPaymentLabel.font = [UIFont systemFontOfSize:14.f];
        pointsPaymentLabel.textColor = [UIColor lightGrayColor];
        pointsPaymentLabel.text = @"";
        [self addSubview:pointsPaymentLabel];
        
        cashPaymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pointsPaymentImageView.frame.origin.x, pointsPaymentImageView.bounds.size.height + pointsPaymentImageView.frame.origin.y + 5, 16, 16)];
        cashPaymentImageView.image = [UIImage imageNamed:@"rmb_blue"];
        [self addSubview:cashPaymentImageView];
        
        cashPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsPaymentLabel.frame.origin.x, cashPaymentImageView.frame.origin.y - 2, 80, 20)];
        cashPaymentLabel.backgroundColor = [UIColor clearColor];
        cashPaymentLabel.font = [UIFont systemFontOfSize:14.f];
        cashPaymentLabel.textColor = [UIColor lightGrayColor];
        cashPaymentLabel.text = @"";
        [self addSubview:cashPaymentLabel];
        
        rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 90, 0, 160/2, 71/2)];
        [rightButton setTitle:NSLocalizedString(@"settlement", @"") forState:UIControlStateNormal];
        rightButton.layer.cornerRadius = 4;
        rightButton.layer.masksToBounds = YES;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [rightButton setBackgroundImage:[UIImage imageWithColor:[UIColor appColor] size:CGSizeMake(120, 26)] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"bottom_button"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
    }
    return self;
}

- (void)setSelectButtonHidden {
    selectButtonHidden = YES;
    selectButton.hidden = YES;
    CGRect sFrame = summariesLabel.frame;
    sFrame.origin.x = sFrame.origin.x - 30;
    summariesLabel.frame = sFrame;
    [rightButton setTitle:NSLocalizedString(@"determine", @"") forState:UIControlStateNormal];
}

- (void)setPayment:(Payment *)payment {
    pointsPaymentLabel.attributedText = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"%d ", payment.points] paymentType:PaymentTypePoints];
    cashPaymentLabel.attributedText = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"%.1f ", payment.cash] paymentType:PaymentTypeCash];
    
    if(!selectButtonHidden) {
        selectButton.selected = [ShoppingCart myShoppingCart].allSelect;
    } else {
        summariesLabel.text = [NSString stringWithFormat:@"共%d件商品 合计:", payment.numberOfMerchandises];
    }
}

- (NSAttributedString *)paymentAttributeStringWithString:(NSString *)paymentString paymentType:(PaymentType)paymentType {
    NSMutableAttributedString *attributePaymentString = [[NSMutableAttributedString alloc] initWithString:paymentString attributes:
                                                         @{
                                                           NSFontAttributeName : [UIFont systemFontOfSize:15.f],
                                                           NSForegroundColorAttributeName :  [UIColor appLightBlue] }];
    
    [attributePaymentString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:(PaymentTypePoints == paymentType ? NSLocalizedString(@"points", @"") : NSLocalizedString(@"yuan", @"")) attributes:
                                                    @{
                                                      NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                                      NSForegroundColorAttributeName :  [UIColor lightGrayColor] }]];
    
    return attributePaymentString;
}

- (void)selectButtonPressed:(id)sender {
    [[ShoppingCart myShoppingCart] setAllSelect:!selectButton.selected];
}

- (void)rightButtonPressed:(id)sender {
    if(self.delegate != nil
       && [self.delegate respondsToSelector:@selector(purchaseButtonPressed:)]) {
        [self.delegate purchaseButtonPressed:sender];
    }
}

@end
