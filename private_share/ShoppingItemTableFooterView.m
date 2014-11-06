//
//  ShoppingItemTableFooterView.m
//  private_share
//
//  Created by Zhao yang on 9/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemTableFooterView.h"
#import "PurchaseViewController.h"
#import "UIImage+Color.h"
#import "UIColor+App.h"
#import "Payment.h"
#import "ShoppingItem.h"
#import "PaymentButton.h"
#import "Account.h"

@implementation RemarkTextField

@synthesize shopShoppingItems;

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x = rect.origin.x + 10;
    rect.size.width = rect.size.width - 10;
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end

@implementation ShoppingItemTableFooterView {
    UILabel *summariesLabel;
    RemarkTextField *remarkTextField;
    
    UIImageView *pointsPaymentImageView;
    UILabel *pointsPaymentLabel;
    
    UIImageView *cashPaymentImageView;
    UILabel *cashPaymentLabel;
    
    UIImageView *postPaymentImageView;
    UILabel *postPaymentLabel;
    
    UIButton *rightButton;
    
    PaymentButton *postPointsPaymentButton;
    PaymentButton *postCashPaymentButton;
    
    UILabel *ArrivedCashLabel;
    UISwitch *arrivedCashSwitch;
}

@synthesize shopShoppingItems = _shopShoppingItems_;
@synthesize purchaseViewController = _purchaseViewController_;

- (instancetype)initWithFrame:(CGRect)frame shopShoppingItems:(ShopShoppingItems *)shopShoppingItems {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *postPaymentTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 30)];
        postPaymentTypeLabel.font = [UIFont systemFontOfSize:16.f];
        postPaymentTypeLabel.text = @"邮资支付方式";
        [self addSubview:postPaymentTypeLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, postPaymentTypeLabel.bounds.size.height + postPaymentTypeLabel.frame.origin.y + 5, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [self addSubview:lineView];
        
        NSInteger pointPostPay = 0;
        NSInteger cashPostPay = 0;
        
        if(![self isActivityPay:shopShoppingItems]) {
            pointPostPay = 300;
//            cashPostPay = 5;   //邮费为0,为了测试
        }
        
//        postPointsPaymentButton = [[PaymentButton alloc] initWithPoint:CGPointMake(10, lineView.frame.origin.y + lineView.bounds.size.height + 10) paymentType:PaymentTypePoints points:pointPostPay returnPoints:0];
        postCashPaymentButton = [[PaymentButton alloc] initWithPoint:CGPointMake(10, lineView.frame.origin.y + lineView.bounds.size.height + 10) paymentType:PaymentTypeCash points:cashPostPay returnPoints:0];
        
//        [postPointsPaymentButton addTarget:self action:@selector(paymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [postCashPaymentButton addTarget:self action:@selector(paymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        postCashPaymentButton.hidden = YES;
        postPointsPaymentButton.hidden = YES;
        postCashPaymentButton.selected = YES;
        
//        [self addSubview:postPointsPaymentButton];
        [self addSubview:postCashPaymentButton];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, postCashPaymentButton.bounds.size.height + postCashPaymentButton.frame.origin.y + 10, frame.size.width - 20, 0.5f)];
        lineView2.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [self addSubview:lineView2];
        
        remarkTextField = [[RemarkTextField alloc] initWithFrame:CGRectMake(10, lineView2.frame.origin.y + lineView2.bounds.size.height + 10, 300, 36)];
        remarkTextField.placeholder = @"留言:";
        remarkTextField.layer.cornerRadius = 8;
        remarkTextField.layer.borderWidth = 1.f;
        remarkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        remarkTextField.font = [UIFont systemFontOfSize:15.f];
        remarkTextField.returnKeyType = UIReturnKeyDone;
        remarkTextField.layer.borderColor = [UIColor colorWithRed:219.f / 255 green:220.f / 255 blue:222.f / 255 alpha:1.0f].CGColor;
        remarkTextField.backgroundColor = [UIColor colorWithRed:241.f / 255.f green:241.f / 255.f blue:243.f / 255.f alpha:1.f];
        [self addSubview:remarkTextField];
        
        //        remarkTextField.frame.origin.y + remarkTextField.bounds.size.height + 10
        //lineView2.frame.origin.y + lineView2.bounds.size.height + 10
        
        summariesLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, remarkTextField.frame.origin.y + remarkTextField.bounds.size.height + 10, 120, 30)];
        summariesLabel.backgroundColor = [UIColor clearColor];
        summariesLabel.font = [UIFont systemFontOfSize:13.f];
        [self setMerchandiseNumber:0];
        [self addSubview:summariesLabel];
        
        pointsPaymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(summariesLabel.frame.origin.x + summariesLabel.frame.size.width + 5, summariesLabel.frame.origin.y + 8, 16, 16)];
        pointsPaymentImageView.image = [UIImage imageNamed:@"points_blue"];
//        [self addSubview:pointsPaymentImageView];
        
        pointsPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsPaymentImageView.frame.origin.x + pointsPaymentImageView.bounds.size.width + 5, pointsPaymentImageView.frame.origin.y - 2, 80, 20)];
        pointsPaymentLabel.backgroundColor = [UIColor clearColor];
        pointsPaymentLabel.font = [UIFont systemFontOfSize:14.f];
        pointsPaymentLabel.textColor = [UIColor lightGrayColor];
        pointsPaymentLabel.text = @"";
//        [self addSubview:pointsPaymentLabel];
        
        cashPaymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pointsPaymentImageView.frame.origin.x, pointsPaymentImageView.bounds.size.height + pointsPaymentImageView.frame.origin.y + 5, 16, 16)];
        cashPaymentImageView.image = [UIImage imageNamed:@"rmb_blue"];
//        [self addSubview:cashPaymentImageView];
        
        cashPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsPaymentImageView.frame.origin.x, cashPaymentImageView.frame.origin.y - 2, 80, 20)];
        cashPaymentLabel.frame = CGRectMake(summariesLabel.frame.origin.x + summariesLabel.frame.size.width, summariesLabel.frame.origin.y + 6, 80, 20);
        cashPaymentLabel.backgroundColor = [UIColor clearColor];
        cashPaymentLabel.font = [UIFont systemFontOfSize:14.f];
        cashPaymentLabel.textColor = [UIColor lightGrayColor];
        cashPaymentLabel.text = @"";
        [self addSubview:cashPaymentLabel];
        
        postPaymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pointsPaymentImageView.frame.origin.x, cashPaymentImageView.bounds.size.height + cashPaymentImageView.frame.origin.y + 5, 16, 16)];
        postPaymentImageView.frame = CGRectMake(cashPaymentLabel.frame.origin.x - 18, cashPaymentLabel.frame.origin.y + cashPaymentLabel.bounds.size.height, 16, 16);
        postPaymentImageView.image = [UIImage imageNamed:@"shipping"];
        [self addSubview:postPaymentImageView];
        
        postPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsPaymentLabel.frame.origin.x, postPaymentImageView.frame.origin.y - 2, 80, 20)];
        postPaymentLabel.frame = CGRectMake(cashPaymentLabel.frame.origin.x, postPaymentImageView.frame.origin.y, 80, 20);
        postPaymentLabel.backgroundColor = [UIColor clearColor];
        postPaymentLabel.font = [UIFont systemFontOfSize:14.f];
        postPaymentLabel.textColor = [UIColor lightGrayColor];
        postPaymentLabel.text = @"";
        [self addSubview:postPaymentLabel];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, postPaymentLabel.frame.origin.y + postPaymentLabel.bounds.size.height+5, frame.size.width - 20, 0.5f)];
        lineView3.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [self addSubview:lineView3];

        ArrivedCashLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, postPaymentLabel.frame.origin.y + postPaymentLabel.bounds.size.height+10 , 250, 30)];
        ArrivedCashLabel.textAlignment = NSTextAlignmentLeft;
        ArrivedCashLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:ArrivedCashLabel];
        
        arrivedCashSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(postPaymentLabel.frame.origin.x, ArrivedCashLabel.frame.origin.y, 15, 20)];
        [arrivedCashSwitch setOn:NO];
        [arrivedCashSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:arrivedCashSwitch];
        
        self.shopShoppingItems = shopShoppingItems;
    }
    return self;
}

- (void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if(self.purchaseViewController != nil && [self.purchaseViewController isKindOfClass:[PurchaseViewController class]]) {
        PurchaseViewController *pVC = (PurchaseViewController *)self.purchaseViewController;
        [pVC refreshSettlementView:isButtonOn];
    }
}

- (void)setMerchandiseNumber:(NSUInteger)number {
    summariesLabel.text = [NSString stringWithFormat:@"共%d件商品   合计:", number];
}

- (NSAttributedString *)paymentAttributeStringWithString:(NSString *)paymentString paymentType:(PaymentType)paymentType {
    NSMutableAttributedString *attributePaymentString = [[NSMutableAttributedString alloc] initWithString:paymentString attributes:
                                                         @{
                                                           NSFontAttributeName : [UIFont systemFontOfSize:15.f],
                                                           NSForegroundColorAttributeName :  [UIColor appLightBlue] }];
    
//    [attributePaymentString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:(PaymentTypePoints == paymentType ? NSLocalizedString(@"points", @"") : NSLocalizedString(@"yuan", @"")) attributes:
//                                                    @{
//                                                      NSFontAttributeName : [UIFont systemFontOfSize:13.f],
//                                                      NSForegroundColorAttributeName :  [UIColor appTextColor] }]];
    
    return attributePaymentString;
}

- (void)setTotalPayment:(Payment *)payment postPaymentType:(PaymentType)postPaymentType postPoints:(NSInteger)postPoints postCash:(float)postCash {
    NSAttributedString *pointsPaymentString = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"%d ", payment.points] paymentType:PaymentTypePoints];
    NSAttributedString *cashPaymentString = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"￥ %.2f ", payment.cash] paymentType:PaymentTypeCash];
    
    NSAttributedString *postPaymentString = nil;
    if(PaymentTypePoints == postPaymentType) {
        postPointsPaymentButton.selected = YES;
        postPaymentString = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"%d ", postPoints] paymentType:PaymentTypePoints];
    } else {
        postCashPaymentButton.selected = YES;
//        postPaymentString = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"￥ %.2f ", postCash] paymentType:PaymentTypeCash];
        postPaymentString = [self paymentAttributeStringWithString:[NSString stringWithFormat:@"￥ %.2f ", 0.00f] paymentType:PaymentTypeCash];  //邮费为0 ，为了测试

    }
    
    CGSize pointsSize = [pointsPaymentString boundingRectWithSize:CGSizeMake(150, pointsPaymentLabel.bounds.size.height) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    
    CGSize cashSize = [cashPaymentString boundingRectWithSize:CGSizeMake(150, cashPaymentLabel.bounds.size.height) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    
    CGSize postSize = [postPaymentString boundingRectWithSize:CGSizeMake(150, postPaymentLabel.bounds.size.height) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    
    CGFloat width = pointsSize.width;
    
    if(cashSize.width > width) {
        width = cashSize.width;
    }
    
    if(postSize.width > width) {
        width = postSize.width;
    }
    
//    CGRect pFrame = pointsPaymentLabel.frame;
//    pFrame.size.width = width;
//    pFrame.origin.x = self.bounds.size.width - width - 12;
//    pointsPaymentLabel.frame = pFrame;
//    
//    CGRect cFrame = cashPaymentLabel.frame;
//    cFrame.size.width = width;
//    cFrame.origin.x = pFrame.origin.x;
//    cashPaymentLabel.frame = cFrame;
//    
//    CGRect postFrame = postPaymentLabel.frame;
//    postFrame.size.width = width;
//    postFrame.origin.x = pFrame.origin.x;
//    postPaymentLabel.frame = postFrame;
//    
//    CGRect piFrame = pointsPaymentImageView.frame;
//    piFrame.origin.x = pFrame.origin.x - piFrame.size.width - 10;
//    pointsPaymentImageView.frame = piFrame;
//    
//    CGRect ciFrame = cashPaymentImageView.frame;
//    ciFrame.origin.x = piFrame.origin.x;
//    cashPaymentImageView.frame = ciFrame;
//    
//    CGRect postIFrame = postPaymentImageView.frame;
//    postIFrame.origin.x = piFrame.origin.x;
//    postPaymentImageView.frame = postIFrame;
//    
//    CGRect sFrame = summariesLabel.frame;
//    sFrame.origin.x = piFrame.origin.x - sFrame.size.width - 10;
//    summariesLabel.frame = sFrame;
    
    pointsPaymentLabel.attributedText = pointsPaymentString;
    cashPaymentLabel.attributedText = cashPaymentString;
    postPaymentLabel.attributedText = postPaymentString;
    [self setMerchandiseNumber:payment.numberOfMerchandises];
}

- (void)paymentButtonPressed:(PaymentButton *)paymentButton {
    if(paymentButton.selected) return;
    paymentButton.selected = !paymentButton.selected;
    if(paymentButton == postPointsPaymentButton) {
        self.shopShoppingItems.postPaymentType = PaymentTypePoints;
        postCashPaymentButton.selected = !paymentButton.selected;
    } else {
        self.shopShoppingItems.postPaymentType = PaymentTypeCash;
        postPointsPaymentButton.selected = !paymentButton.selected;
    }
    [self refresh];
    
    if(self.purchaseViewController != nil && [self.purchaseViewController isKindOfClass:[PurchaseViewController class]]) {
        PurchaseViewController *pVC = (PurchaseViewController *)self.purchaseViewController;
        [pVC refreshSettlementView];
    }
}

- (void)setShopShoppingItems:(ShopShoppingItems *)shopShoppingItems {
    _shopShoppingItems_ = shopShoppingItems;
    remarkTextField.shopShoppingItems = shopShoppingItems;
    [self refresh];
}

- (void)refresh {
    if(_shopShoppingItems_ != nil) {
        remarkTextField.text = _shopShoppingItems_.remark;
        NSInteger points = 0;
        float cash = 0;
        if(![self isActivityPay]) {
            if(PaymentTypePoints == _shopShoppingItems_.postPaymentType) {
                points = 300;
            } else {
                cash = 5.0f;
            }
        }
        [self setTotalPayment:_shopShoppingItems_.totalSelectPayment postPaymentType:_shopShoppingItems_.postPaymentType postPoints:points postCash:cash];
    } else {
        remarkTextField.text = @"";
    }
//    [Account currentAccount].points = 0;
    if ([Account currentAccount].points > 0) {
        arrivedCashSwitch.hidden = NO;

        NSMutableAttributedString *pointsString = [[NSMutableAttributedString alloc] initWithString:@"可以用" attributes:
                                                   @{
                                                     NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                                     NSForegroundColorAttributeName :  [UIColor blackColor] }];
        
        [pointsString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",[Account currentAccount].points] attributes:
                                              @{
                                                NSFontAttributeName : [UIFont systemFontOfSize:15.f],
                                                NSForegroundColorAttributeName :  [UIColor appLightBlue] }]];
        [pointsString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"米米抵现金" attributes:
                                              @{
                                                NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                                NSForegroundColorAttributeName :  [UIColor blackColor] }]];
        
        CGFloat pointF = [Account currentAccount].points;
        [pointsString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",pointF/100] attributes:
                                              @{
                                                NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                                NSForegroundColorAttributeName :  [UIColor appLightBlue] }]];
        
        [pointsString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"元" attributes:
                                              @{
                                                NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                                NSForegroundColorAttributeName :  [UIColor blackColor] }]];
        
        ArrivedCashLabel.attributedText = pointsString;
    }else{
        ArrivedCashLabel.text = @"您现在的米米为0,不能抵现金!";
        arrivedCashSwitch.hidden = YES;
    }
    
}

- (BOOL)isActivityPay:(ShopShoppingItems *)shopShoppingItems {
    BOOL is_activity_pay = NO;
    if(shopShoppingItems != nil) {
        if(shopShoppingItems.shoppingItems.count > 0) {
            ShoppingItem *si = [shopShoppingItems.shoppingItems objectAtIndex:0];
            is_activity_pay = si.merchandise.isActivity;
        }
    }
    return is_activity_pay;
}

- (BOOL)isActivityPay {
    return [self isActivityPay:_shopShoppingItems_];
}

- (void)setPurchaseViewController:(id)purchaseViewController {
    _purchaseViewController_ = purchaseViewController;
    if(_purchaseViewController_ != nil) {
        if([_purchaseViewController_ isKindOfClass:[PurchaseViewController class]]) {
            PurchaseViewController *pViewController = (PurchaseViewController *)_purchaseViewController_;
            remarkTextField.delegate = pViewController;
        }
    }
}

@end
