//
//  ShoppingItemFooterView.m
//  private_share
//
//  Created by Zhao yang on 7/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemFooterView.h"
#import "UIImage+Color.h"
#import "UIColor+App.h"
#import "Payment.h"
#import "ShoppingItem.h"
#import "PaymentButton.h"

@implementation ShoppingItemFooterView {
    UILabel *summariesLabel;
    
    UIImageView *pointsPaymentImageView;
    UILabel *pointsPaymentLabel;
    
    UIImageView *cashPaymentImageView;
    UILabel *cashPaymentLabel;
    
    UIButton *rightButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        summariesLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 30)];
        summariesLabel.backgroundColor = [UIColor clearColor];
        summariesLabel.font = [UIFont systemFontOfSize:12.f];
        [self setMerchandiseNumber:0];
        [self addSubview:summariesLabel];
        
        pointsPaymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(summariesLabel.frame.origin.x + summariesLabel.frame.size.width + 5, 5 + 2, 16, 16)];
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
        
        /*
        rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 60 - 10, 10, 60, 26)];
        rightButton.layer.cornerRadius = 4;
        rightButton.layer.masksToBounds = YES;
        [rightButton setBackgroundImage:[UIImage imageWithColor:[UIColor appColor] size:CGSizeMake(120, 26)] forState:UIControlStateNormal];
        [self addSubview:rightButton];
         */
    }
    return self;
}

- (void)setMerchandiseNumber:(NSUInteger)number {
    summariesLabel.text = [NSString stringWithFormat:@"共%d件商品   合计:", number];
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

- (void)setTotalPayment:(Payment *)payment {
    NSAttributedString *pointsPaymentString = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"%d ", payment.points] paymentType:PaymentTypePoints];
    NSAttributedString *cashPaymentString = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"%.1f ", payment.cash] paymentType:PaymentTypeCash];

    
    CGSize pointsSize = [pointsPaymentString boundingRectWithSize:CGSizeMake(150, pointsPaymentLabel.bounds.size.height) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    
    CGSize cashSize = [cashPaymentString boundingRectWithSize:CGSizeMake(150, cashPaymentLabel.bounds.size.height) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    
    CGFloat width = pointsSize.width;
    if(cashSize.width > width) {
        width = cashSize.width;
    }
    
    CGRect pFrame = pointsPaymentLabel.frame;
    pFrame.size.width = width;
    pFrame.origin.x = self.bounds.size.width - width - 12;
    pointsPaymentLabel.frame = pFrame;
    
    CGRect cFrame = cashPaymentLabel.frame;
    cFrame.size.width = width;
    cFrame.origin.x = pFrame.origin.x;
    cashPaymentLabel.frame = cFrame;
    
    CGRect piFrame = pointsPaymentImageView.frame;
    piFrame.origin.x = pFrame.origin.x - piFrame.size.width - 10;
    pointsPaymentImageView.frame = piFrame;
    
    CGRect ciFrame = cashPaymentImageView.frame;
    ciFrame.origin.x = piFrame.origin.x;
    cashPaymentImageView.frame = ciFrame;
    
    CGRect sFrame = summariesLabel.frame;
    sFrame.origin.x = piFrame.origin.x - sFrame.size.width - 10;
    summariesLabel.frame = sFrame;
    
    pointsPaymentLabel.attributedText = pointsPaymentString;
    cashPaymentLabel.attributedText = cashPaymentString;
    [self setMerchandiseNumber:payment.numberOfMerchandises];
}

@end
