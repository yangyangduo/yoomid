//
//  PurchaseViewController.h
//  private_share
//
//  Created by Zhao yang on 7/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SettlementView.h"
#import "ContactService.h"
#import "SelectContactAddressViewController.h"
#import "TransitionViewController.h"
#import "YoomidRectModalView.h"
#import "CategoryButtonItem.h"
#import "WXPayRequest.h"
#import "AliPaymentModal.h"
#import "AddContactInfoViewController.h"

//@protocol PurchanseVCDelegate <NSObject>
//
//- (void)WXPay:(WXPayRequest *)wxPay;
//- (void)AilPay:(AliPaymentModal *)aliPay;
//- (void)PointPay;
//
//@end

@interface PurchaseViewController : TransitionViewController<UITableViewDataSource, UITableViewDelegate, SettlementViewDelegate, selectContactInfoDelegate, UIAlertViewDelegate, ModalViewDelegate, UITextFieldDelegate,ShareDeletage,CategoryButtonItemDelegate,YoomidRectModalViewDelegate,AddContactInfoDelegate>

//@property (nonatomic, assign) id<PurchanseVCDelegate>delegate;

- (instancetype)initWithShopShoppingItemss:(NSArray *)shopShoppingItemss isFromShoppingCart:(BOOL)isFromShoppingCart;

- (void)refreshSettlementView;

- (void)refreshSettlementView:(BOOL)isArrivedCash;
@end
