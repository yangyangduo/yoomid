//
//  ShoppingItemHeaderView.m
//  private_share
//
//  Created by Zhao yang on 7/18/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemHeaderView.h"
#import "ShoppingCart.h"
#import "AppDelegate.h"
#import "MerchandiseService.h"
#import "XXAlertView.h"
#import "BaseViewController.h"
#import "PayOrderViewController.h"

@implementation ShoppingItemHeaderView {
    UIButton *selectButton;
    UILabel *titleLabel;
    BOOL hideSelectButton;
    
    UIButton *moreButton;
}

@synthesize shopId = _shopId_;

@synthesize wxPay = _wxPay;
@synthesize total_points = _total_points;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 44, frame.size.width, 44)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [backgroundView addSubview:lineView];
        
        selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateNormal];
//        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateHighlighted];
        [selectButton setImage:[UIImage imageNamed:@"cb_select"] forState:UIControlStateSelected];
        [backgroundView addSubview:selectButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectButton.bounds.size.width, 0, 260, 44)];
        titleLabel.text = @"";
        titleLabel.font = [UIFont systemFontOfSize:17.f];
        [backgroundView addSubview:titleLabel];
        
        moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 40, 10, 23, 23)];
        [moreButton addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        moreButton.hidden = YES;
        [backgroundView addSubview:moreButton];
    }
    return self;
}

- (void)setSelectButtonHidden {
    hideSelectButton = YES;
    selectButton.hidden = YES;
    CGRect tFrame = titleLabel.frame;
    tFrame.origin.x = 10;
    titleLabel.frame = tFrame;
}

- (void)setOrderId:(NSString *)orderId {
    titleLabel.text = [NSString stringWithFormat:@"单号: %@", orderId];
}

- (void)setShopId:(NSString *)shopId {
    _shopId_ = shopId;
    titleLabel.text = @"小吉商城";
    if(!hideSelectButton) {
        selectButton.selected = [[ShoppingCart myShoppingCart] selectWithShopId:_shopId_];
    }
}

- (void)selectButtonPressed:(id)sender {
    [[ShoppingCart myShoppingCart] setSelect:!selectButton.selected forShopId:self.shopId];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setMoreButtonShow
{
    moreButton.hidden = NO;
}

- (void)setMoreButtonHidden
{
    moreButton.hidden = YES;
}

- (void)moreButtonPressed:(id)sender {
    NSMutableArray *categories = [NSMutableArray array];
    [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"weixinPay" title:@"微信支付" imageName:@"wxpay"]];
    [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"taobaoPay" title:@"淘宝支付" imageName:@"taobaopay"]];
    [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"deleteOrders" title:@"删除订单" imageName:@"order_delete"]];
    
    NSString *message = nil;
    float pickerHeight = 0.f;
    if (self.total_points > 0) {
        message = [NSString stringWithFormat:@"请选择支付方式.您已经支付%.0f米米,删除订单将返回已支付的米米!",self.total_points];
        pickerHeight = 340;
    }else{
        message = @"请选择支付方式或删除订单!";
        pickerHeight = 310;
    }
    CashPaymentTypePicker *modalView = [[CashPaymentTypePicker alloc] initWithSize:CGSizeMake(280, pickerHeight)message:message buttonItems:categories];
    modalView.delegate = self;
//    modalView.modalViewDelegate = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

//    NSDictionary *d = [self.wxPay toJson];
//    NSLog(@"%@",d);
    [modalView showInView:app.window completion:nil];
}

- (void)categoryButtonItemDidSelectedWithIdentifier:(NSString *)identifier {
    PayOrderViewController *payOrderVC = nil;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if ([identifier isEqualToString:@"weixinPay"]) {
        payOrderVC = [[PayOrderViewController alloc] init];
        payOrderVC.paymentMode = PaymentModeWXPay;
        payOrderVC.wxPayment = self.wxPay;
        [[app topViewController].navigationController pushViewController:payOrderVC animated:YES];
//        return;
        
//        [self.wxPay payCash];
    }else if ([identifier isEqualToString:@"taobaoPay"]){
        payOrderVC = [[PayOrderViewController alloc] init];
        payOrderVC.paymentMode = PaymentModeAliPay;
        payOrderVC.aliPayment = self.aliPay;
        [[app topViewController].navigationController pushViewController:payOrderVC animated:YES];
//        return;
    }else if ([identifier isEqualToString:@"deleteOrders"]){
        [[XXAlertView currentAlertView] setMessage:@"正在删除订单..." forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];

        MerchandiseService *service = [[MerchandiseService alloc] init];
        [service deleteOrders:self.wxPay.out_trade_no target:self success:@selector(Success:) failure:@selector(Failure:) userInfo:nil];
    }
}

- (void)Success:(HttpResponse *)resp {
    if (resp.statusCode == 202) {
        [[XXAlertView currentAlertView] setMessage:@"订单删除成功!" forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] delayDismissAlertView];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteOrdersRefresh)]) {
            [self.delegate deleteOrdersRefresh];
        }
        return;
    }
    
    [self Failure:resp];
}

- (void)Failure:(HttpResponse *)resp {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseViewController *topVC = (BaseViewController *)[app topViewController];
    [topVC handleFailureHttpResponse:resp];
}
@end
