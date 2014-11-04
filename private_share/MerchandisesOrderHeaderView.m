//
//  MerchandisesOrderHeaderView.m
//  private_share
//
//  Created by 曹大为 on 14/11/4.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "MerchandisesOrderHeaderView.h"
#import "AppDelegate.h"
#import "XXAlertView.h"
#import "PayOrderViewController.h"
#import "UINavigationViewInitializer.h"
#import "MerchandiseService.h"

@implementation MerchandisesOrderHeaderView
{
    UILabel *titleLabel;
    UIButton *moreButton;

    MerchandiseOrder *_order_;
}

@synthesize wxPay = _wxPay;
@synthesize aliPay = _aliPay;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 44, frame.size.width, 44)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [backgroundView addSubview:lineView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 44)];
        titleLabel.text = @"";
        titleLabel.font = [UIFont systemFontOfSize:17.f];
        [backgroundView addSubview:titleLabel];
        
        moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 40, 10, 23, 23)];
        [moreButton addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
//        moreButton.hidden = YES;
        [backgroundView addSubview:moreButton];
    }
    return self;
}

- (void)moreButtonPressed:(id)sender {
    if (_order_ != nil) {
        NSMutableArray *categories = [NSMutableArray array];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if (_order_.orderState == MerchandiseOrderStateUnCashPayment) {//订单状态：未支付
            [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"weixinPay" title:@"微信支付" imageName:@"wxpay"]];
            [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"taobaoPay" title:@"淘宝支付" imageName:@"taobaopay"]];
            [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"deleteOrders" title:@"删除订单" imageName:@"order_delete"]];
            NSString *message = nil;
            float pickerHeight = 0.f;
            if (_order_.totalPoints > 0) {
                message = [NSString stringWithFormat:@"请选择支付方式.您已经用%d米米抵现金,删除订单将返回已支付的米米!",_order_.totalPoints];
                pickerHeight = 340;
            }else{
                message = @"请选择支付方式或删除订单!";
                pickerHeight = 310;
            }
            CashPaymentTypePicker *modalView = [[CashPaymentTypePicker alloc] initWithSize:CGSizeMake(280, pickerHeight)message:message buttonItems:categories];
            modalView.btnItemDelegate = self;
            [modalView showInView:app.window completion:nil];
        }else if (_order_.orderState == MerchandiseOrderStateConfirmed){//订单状态：完成
            CashPaymentTypePicker *picker = [[CashPaymentTypePicker alloc] initWithSize:CGSizeMake(280, 250) message:@"亲,您的物品已被签收了哦!" title1:_order_.loginame title2:_order_.sendno];
            [picker showInView:app.window completion:nil];
        }else{//订单状态:支付未发货 or 支付已发货
            if (_order_.orderState == MerchandiseOrderStateSubmitted) {
                CashPaymentTypePicker *picker = [[CashPaymentTypePicker alloc] initWithSize:CGSizeMake(280, 200) message:@"亲,您的物品正在等待发货中,请耐心等候!" title1:nil title2:nil];
                [picker showInView:app.window completion:nil];
            }else if (_order_.orderState == MerchandiseOrderStateUnConfirmed){
                CashPaymentTypePicker *picker = [[CashPaymentTypePicker alloc] initWithSize:CGSizeMake(280, 250) message:@"亲,您的物品已在投奔你的怀抱途中,请注意查收!" title1:_order_.loginame title2:_order_.sendno];
                [picker showInView:app.window completion:nil];

            }
        }
    }
}

- (void)categoryButtonItemDidSelectedWithIdentifier:(NSString *)identifier {
    PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:payOrderVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    
    if ([identifier isEqualToString:@"weixinPay"]) {
        payOrderVC.paymentMode = PaymentModeWXPay;
        payOrderVC.wxPayment = self.wxPay;
        [[app topViewController] presentViewController:navigationController animated:YES completion:^{
        }];
    }else if ([identifier isEqualToString:@"taobaoPay"]){
        payOrderVC.paymentMode = PaymentModeAliPay;
        payOrderVC.aliPayment = self.aliPay;
        [[app topViewController] presentViewController:navigationController animated:YES completion:^{
        }];
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

- (void)setMerchandiseOrder:(MerchandiseOrder *)merchandiseOrder
{
    if (merchandiseOrder == nil) {
        titleLabel.text = @"";
        _order_ = nil;
    }else{
        _order_ = merchandiseOrder;
        titleLabel.text = [NSString stringWithFormat:@"单号:%@",merchandiseOrder.orderId];
    }
}
@end
