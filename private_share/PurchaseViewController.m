//
//  PurchaseViewController.m
//  private_share
//
//  Created by Zhao yang on 7/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>

#import "PurchaseViewController.h"
#import "HomeViewController.h"

#import "ContactDisplayView.h"
#import "ShoppingItemTableViewCell.h"
#import "ShoppingItemTableHeaderView.h"
#import "ShoppingItemTableFooterView.h"
#import "MerchandiseOrdersViewController.h"
#import "UINavigationViewInitializer.h"

#import "ShoppingCart.h"
#import "Account.h"
#import "UIDevice+ScreenSize.h"
#import "MerchandiseService.h"
#import "DiskCacheManager.h"
#import "OrderResult.h"
#import "ReturnMessage.h"
#import "CashPaymentTypePicker.h"
#import "alipay/AlixLibService.h"
#import "PayOrderViewController.h"
#import "AllShopInfo.h"
#import "Shop.h"
#import "Consignee.h"
#import "AllConsignee.h"

@implementation PurchaseViewController {
    UITableView *_table_view_;
    SettlementView *settlementView;
    ContactDisplayView *contactDisplayView;
    
    NSArray *_shopShoppingItemss_;
    
    NSString *_default_contact_id_;
    NSMutableArray *contacts;
    NSInteger _select;
    
    BOOL _is_from_shopping_cart_;
    BOOL keyboardIsShow;
    
    __weak UITextField *lastActiveTextFiled;
    UITapGestureRecognizer *resignKeyboardGesture;
    
    WXPayRequest *wxPayRequest;
    AliPaymentModal *aliPay;
    
    NSString *_arrivedCash;
    
    NSString *orderStr;
}

- (instancetype)initWithShopShoppingItemss:(NSArray *)shopShoppingItemss isFromShoppingCart:(BOOL)isFromShoppingCart {
    self = [super init];
    if(self) {
        _shopShoppingItemss_ = shopShoppingItemss;
        _is_from_shopping_cart_ = isFromShoppingCart;
        resignKeyboardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureOnKeyboardShow:)];
        _select = 0;
        
        _arrivedCash = @"0";//0 不抵用现金  1抵用现金
        
        [ShoppingCart myShoppingCart].orderConsignee = nil;
        
//        if ([[AllConsignee myAllConsignee] isEmpty]) {
            [[AllConsignee myAllConsignee] getContact];
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"confirm_order", @"");
    
    orderStr = nil;
    
    wxPayRequest = [[WXPayRequest alloc]init];
    aliPay = [[AliPaymentModal alloc] init];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContactArray:) name:@"updateContactArray" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteContactArray:) name:@"deleteContactArray" object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"order"] style:UIBarButtonItemStylePlain target:self action:@selector(showMerchandiseOrderViewController)];

    settlementView = [[SettlementView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 60, self.view.bounds.size.width, 60)];
    settlementView.delegate = self;
    [settlementView setSelectButtonHidden];
    [self.view addSubview:settlementView];
    
    _table_view_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 60) style:UITableViewStyleGrouped];
    _table_view_.backgroundColor = [UIColor clearColor];
    _table_view_.alwaysBounceVertical = YES;
    _table_view_.delegate = self;
    _table_view_.dataSource = self;
    _table_view_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table_view_];
    
//    contactDisplayView = [[ContactDisplayView alloc] initWithFrame:
//                          CGRectMake(0, -kContactDisplayViewHeight, [UIScreen mainScreen].bounds.size.width, 0) contact:[ShoppingCart myShoppingCart].orderContact];
    
    contactDisplayView = [[ContactDisplayView alloc] initWithFrame:
                          CGRectMake(0, -kContactDisplayViewHeight, [UIScreen mainScreen].bounds.size.width, 0)];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushContactInfo:)];
    [contactDisplayView addGestureRecognizer:tapGesture2];
    
    _table_view_.contentInset = UIEdgeInsetsMake(contactDisplayView.bounds.size.height, 0, 0, 0);
    [_table_view_ addSubview:contactDisplayView];
    
    if(_is_from_shopping_cart_) {
        [self setRightPanDismissWithTransitionStyle];
    } else {
        self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    }
    
    [self refreshSettlementView];
//    [self mayGetContactInfo];
}

#pragma mark -
#pragma mark Keyboards

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    Consignee * consignee = [[AllConsignee myAllConsignee] currentConsignee];
    [contactDisplayView setCurrentConsignee:consignee];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == nil) return NO;
    
    if([textField isKindOfClass:[RemarkTextField class]]) {
        RemarkTextField *remarkTextField = (RemarkTextField *)textField;
        ShopShoppingItems *ssi = remarkTextField.shopShoppingItems;
        if(ssi != nil) {
            ssi.remark = remarkTextField.text;
        }
    }
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    lastActiveTextFiled = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    lastActiveTextFiled = nil;
}

- (void)handleTapGestureOnKeyboardShow:(UITapGestureRecognizer *)tapGesture {
    [self textFieldShouldReturn:lastActiveTextFiled];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if(keyboardIsShow) return;
    keyboardIsShow = YES;
    BOOL gestureExists = NO;
    for(UIGestureRecognizer *gesture in _table_view_.gestureRecognizers) {
        if(gesture == resignKeyboardGesture) {
            gestureExists = YES;
            break;
        }
    }
    if(!gestureExists) {
        [_table_view_ addGestureRecognizer:resignKeyboardGesture];
    }
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3f animations:^{
        _table_view_.contentInset = UIEdgeInsetsMake(_table_view_.contentInset.top, 0, keyboardFrame.size.height - 20, 0);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if(!keyboardIsShow) return;
    keyboardIsShow = NO;
    [_table_view_ removeGestureRecognizer:resignKeyboardGesture];
    [UIView animateWithDuration:0.3f animations:^{
        _table_view_.contentInset = UIEdgeInsetsMake(_table_view_.contentInset.top, 0, 0, 0);
    }];
}

#pragma mark -
#pragma mark Contacts

//- (void)deleteContactArray:(NSNotification*)notif {
//    contacts = notif.object;
//    if (contacts.count > 0) {
//        _select = 0;
//        [ShoppingCart myShoppingCart].orderContact = [contacts objectAtIndex:0];
//    }
//    [contactDisplayView setCurrentContact:[ShoppingCart myShoppingCart].orderContact];
//}
//
//- (void)updateContactArray:(NSNotification*)notif {
//    contacts = notif.object;
//    [ShoppingCart myShoppingCart].orderContact = [contacts objectAtIndex:_select];
//    [contactDisplayView setCurrentContact:[ShoppingCart myShoppingCart].orderContact];
//}

- (void)mayGetContactInfo {
//    BOOL isExpired;
//    NSArray *_contacts_ = [[DiskCacheManager manager] contacts:&isExpired];
//    
//    if(_contacts_ != nil) {
//        contacts = [NSMutableArray arrayWithArray:_contacts_];
//        [contactDisplayView setCurrentContact:[self defaultContact]];
//        [ShoppingCart myShoppingCart].orderContact = [self defaultContact];
//    }
    
//    if(isExpired || _contacts_ == nil) {
    [self getContactInfo];
//    }
}

- (void)getContactInfo {
    ContactService *contactService = [[ContactService alloc]init];
    [contactService getContactInfo:self success:@selector(getContactSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getContactSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200 && resp.body != nil) {
        if(contacts == nil) {
            contacts = [NSMutableArray array];
        } else {
            [contacts removeAllObjects];
        }
        NSMutableArray *_contacts_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        Consignee *defauleContact = nil;
        if(_contacts_ != nil) {
            for(int i=0; i<_contacts_.count; i++) {
                NSDictionary *contactJson = [_contacts_ objectAtIndex:i];
                Consignee *consignee = [[Consignee alloc] initWithJson:contactJson];
                [contacts addObject:consignee];
                
                //购物车里的收货人为空的话，也就是第一次进入 确认订单页面
                if ([ShoppingCart myShoppingCart].orderConsignee == nil) {
                    if ([consignee.isDefault isEqualToString:@"1"]) {  //读取默认收货人 到 购物车收货人
                        defauleContact = consignee;
                    }
                    if (defauleContact == nil) {  //读取第一个 到 购物车收货人
                        defauleContact = [contacts objectAtIndex:0];
                    }
                    [ShoppingCart myShoppingCart].orderConsignee = defauleContact;
                }else{   //购物车里的收货人不为空  更新、
                    if ([[ShoppingCart myShoppingCart].orderConsignee.identifier isEqualToString:consignee.identifier]) {
                        [ShoppingCart myShoppingCart].orderConsignee = consignee;
                    }
                }
            }
//            [contactDisplayView setCurrentConsignee:defauleContact];
            [contactDisplayView setCurrentConsignee:[ShoppingCart myShoppingCart].orderConsignee];
        }
        
        /*
        Contact *defaultContact = nil;
        NSMutableArray *_contacts_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(_contacts_ != nil) {
            for(int i=0; i<_contacts_.count; i++) {
                NSDictionary *contactJson = [_contacts_ objectAtIndex:i];
                Contact *contact = [[Contact alloc] initWithJson:contactJson];
                [contacts addObject:contact];
                if(_default_contact_id_ != nil && [contact.identifier isEqualToString:_default_contact_id_]) {
                    contact.isDefault = YES;
                    defaultContact = contact;
                } else {
                    contact.isDefault = NO;
                }
            }
        }
        
        if(defaultContact == nil && contacts.count > 0) {
            Contact *contact = [contacts objectAtIndex:0];
            contact.isDefault = YES;
            defaultContact = contact;
        }
        //
        [[DiskCacheManager manager] setContacts:contacts];
        
        [ShoppingCart myShoppingCart].orderContact = defaultContact == nil ? nil : [defaultContact copy];
        [contactDisplayView setCurrentContact:defaultContact];
         */
    } else {
        [self handleFailureHttpResponse:resp];
    }
}

//- (Contact *)defaultContact {
//    _default_contact_id_ = nil;
//    if(contacts == nil || contacts.count == 0) return nil;
//    for(int i=0; i<contacts.count; i++) {
//        Contact *contact = [contacts objectAtIndex:i];
//        if(contact.isDefault) {
//            _default_contact_id_ = contact.identifier;
//            return contact;
//        }
//    }
//    return nil;
//}

#pragma mark AddContactInfo delegate
- (void)addContactSuccess
{
    [self getContactInfo];
}

- (void)pushContactInfo:(id)sender {
//    if (contacts == nil || contacts.count == 0) {
    if ([[AllConsignee myAllConsignee] isEmpty]) {
        AddContactInfoViewController *add = [[AddContactInfoViewController alloc]init];
        add.addDelegate = self;
        [self.navigationController pushViewController:add animated:YES];
    }
    else
    {
        SelectContactAddressViewController *selectContactAddress = [[SelectContactAddressViewController alloc]initWithContactInfo:contacts selected:_select];
        selectContactAddress.delegate = self;
        [self.navigationController pushViewController:selectContactAddress animated:YES];
    }
}

-(void)contactInfo:(Contact *)contact selectd:(NSInteger)select {
    [ShoppingCart myShoppingCart].orderContact = contact;
    [ShoppingCart myShoppingCart].orderConsignee = [contacts objectAtIndex:select];
//    [contactDisplayView setCurrentContact:[ShoppingCart myShoppingCart].orderContact];
//    [contactDisplayView setCurrentConsignee:[contacts objectAtIndex:select]];
//    [contactDisplayView setCurrentConsignee:[ShoppingCart myShoppingCart].orderConsignee];
    [contactDisplayView setCurrentConsignee:[[AllConsignee myAllConsignee] currentConsignee]];
    _select = select;
}

#pragma mark -
#pragma mark 
- (void)showMerchandiseOrderViewController {
    [self.navigationController pushViewController:[[MerchandiseOrdersViewController alloc] init] animated:YES];
}

- (void)popViewController {
    if(_is_from_shopping_cart_) {
        [self rightPopViewControllerAnimated:YES];
    } else {
        [self rightDismissViewControllerAnimated:YES];
    }
}

- (void)refreshSettlementView {
    if(_is_from_shopping_cart_) {
        [settlementView setPayment:[ShoppingCart myShoppingCart].totalSelectPaymentWithPostPay];
    } else {
        Payment *totalPayment = [Payment emptyPayment];
        for(int i=0; i<_shopShoppingItemss_.count; i++) {
            ShopShoppingItems *ssis = [_shopShoppingItemss_ objectAtIndex:i];
            [totalPayment addWithPayment:ssis.totalSelectPaymentWithPostPay];
        }
        [settlementView setPayment:totalPayment];
    }
}
//米米抵现金switch 事件
- (void)refreshSettlementView:(BOOL)isArrivedCash
{
    if (isArrivedCash) {
        _arrivedCash = @"1";
        Payment *totalPayment = nil;
        
        if(_is_from_shopping_cart_) {
            totalPayment = [ShoppingCart myShoppingCart].totalSelectPaymentWithPostPay;
//            [settlementView setPayment:[ShoppingCart myShoppingCart].totalSelectPaymentWithPostPay];
        } else {
            totalPayment = [Payment emptyPayment];
            for(int i=0; i<_shopShoppingItemss_.count; i++) {
                ShopShoppingItems *ssis = [_shopShoppingItemss_ objectAtIndex:i];
                [totalPayment addWithPayment:ssis.totalSelectPaymentWithPostPay];
            }
        }
//        totalPayment.cash = 15.0;
//        [Account currentAccount].points = 2600.0;
        CGFloat pointToCash = [Account currentAccount].points/100.0f;
        totalPayment.cash = totalPayment.cash-pointToCash <= 0 ? 0.f : totalPayment.cash-pointToCash;
        [settlementView setPayment:totalPayment];
    }else
    {
        _arrivedCash = @"0";
        [self refreshSettlementView];
    }
}

#pragma mark -
#pragma mark Modal view delegate

- (void)modalViewDidClosed:(ModalView *)modalView {
    [self popViewController];
}

#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shopShoppingItemss_ == nil ? 0 : _shopShoppingItemss_.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShopShoppingItems *ssi = [_shopShoppingItemss_ objectAtIndex:section];
    return ssi.selectShoppingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    ShopShoppingItems *ssi = [_shopShoppingItemss_ objectAtIndex:indexPath.section];
    ShoppingItem *si = [ssi.selectShoppingItems objectAtIndex:indexPath.row];
    ShoppingItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ShoppingItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.shoppingCartViewController = self;
    }
    cell.shoppingItem = si;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopShoppingItems *ssi = [_shopShoppingItemss_ objectAtIndex:indexPath.section];
    return [ShoppingItemTableViewCell calcCellHeightWithShoppingItem:[ssi.selectShoppingItems objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 240;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShopShoppingItems *shopShoppingItems = [_shopShoppingItemss_ objectAtIndex:section];
    ShoppingItemTableHeaderView *headerView = [[ShoppingItemTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    [headerView setSelectButtonHidden];
    headerView.shopId = shopShoppingItems.shopID;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ShopShoppingItems *shopShoppingItems = [_shopShoppingItemss_ objectAtIndex:section];
    ShoppingItemTableFooterView *footerView = [[ShoppingItemTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [self tableView:tableView heightForFooterInSection:section]) shopShoppingItems:shopShoppingItems];
    footerView.purchaseViewController = self;
    return footerView;
}

#pragma mark -
#pragma mark Submit merchandise order
//下订单按钮
- (void)purchaseButtonPressed:(id)sender {
//    if([ShoppingCart myShoppingCart].orderContact.isEmpty) {
//    if([ShoppingCart myShoppingCart].orderConsignee == nil) {
    if([AllConsignee myAllConsignee].currentConsignee == nil) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"contact_required", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if (orderStr != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已生成订单,请不要重复操作.您可以点击右上角的我的商品页面查看订单信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray *ordersToSubmit = [NSMutableArray array];
    NSMutableString *shopBodys = [[NSMutableString alloc] init];
    NSMutableString *aliShopBodys = [[NSMutableString alloc] init];

    NSString *shopIdStr = nil;
    for(ShopShoppingItems *ssi in _shopShoppingItemss_) {
        shopIdStr = ssi.shopID;
        
        NSMutableArray *shoppingItems = [NSMutableArray array];
        NSMutableString *merchandiseName = [[NSMutableString alloc] init];

        for(ShoppingItem *si in ssi.selectShoppingItems)
        {
            [shopBodys appendString:[NSString stringWithFormat:@"%@;",si.merchandise.name]];
            [aliShopBodys appendString:[NSString stringWithFormat:@"%@;",si.merchandise.name]];
            [merchandiseName appendString:[NSString stringWithFormat:@"%@;",si.merchandise.name]];

            [shoppingItems addObject:@{
                                       @"merchandiseId" : si.merchandise.identifier,
                                       @"number" : [NSNumber numberWithInteger:si.number],
                                       @"paymentType" : [NSNumber numberWithUnsignedInteger:si.paymentType],
                                       @"properties" : si.propertiesAsString
                                       }];
        }
        NSDictionary *shopOrder = @{
                                    @"basicInfo" : @{
                                    @"shopId" : ssi.shopID,
                                    @"shippingPaymentType" : [NSNumber numberWithInteger:ssi.postPaymentType],
//                                    @"contactId" : [ShoppingCart myShoppingCart].orderConsignee.identifier,
//                                    @"contactId" : contactDisplayView.currentConsignee.identifier,
                                    @"contactId" : [AllConsignee myAllConsignee].currentConsignee.identifier,
                                    @"remark" : (ssi.remark == nil ? @"" : ssi.remark),
                                    },
                                    @"shoppingItems" : shoppingItems
        };
//        Consignee *cc = [contacts objectAtIndex:0];
//        Consignee *ccc = [contacts objectAtIndex:1];
        [ordersToSubmit addObject:shopOrder];
        
        wxPayRequest.merchandiseName = merchandiseName;
    }
    
    NSArray *allshopInfo = [[AllShopInfo allShopInfo] getAllShopInfo];
    NSString *shopname = nil;

    if (allshopInfo.count > 0) {
        for (int i = 0; i < allshopInfo.count; i++) {
            Shop *shopinfo = [allshopInfo objectAtIndex:i];
            if ([shopinfo.shopId isEqualToString:shopIdStr]) {
                shopname = shopinfo.shopName;
            }else if ([shopIdStr isEqualToString:@"0000"]){
                shopname = @"有米得商城";
            }
        }
    }
    
    [shopBodys appendString:[NSString stringWithFormat:@"%@:",shopname]];
    aliPay.subject = shopname;
    wxPayRequest.mallName = shopname;
    
    wxPayRequest.bodys = shopBodys;
    aliPay.body = aliShopBodys;
    
#ifdef DEBUG
    [JsonUtil printArrayAsJsonFormat:ordersToSubmit];
#endif
    
    [[XXAlertView currentAlertView] setMessage:@"正在提交" forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    MerchandiseService *service =  [[MerchandiseService alloc] init];
//    [service submitOrders:[JsonUtil createJsonDataFromArray:ordersToSubmit] target:self success:@selector(submitOrdersSuccess:) failure:@selector(submitOrdersFailure:) userInfo:nil];
    [service submitOrdersDiyong:_arrivedCash body:[JsonUtil createJsonDataFromArray:ordersToSubmit] target:self success:@selector(submitOrdersSuccess:) failure:@selector(submitOrdersFailure:) userInfo:nil];
}
//提交订单成功,返回 订单号、需要支付的现金、积分
- (void)submitOrdersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
//        [self dismissViewControllerAnimated:NO completion:^{
            NSDictionary *_order_result_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
            if(_order_result_json_ != nil) {
                OrderResult *orderResult = [[OrderResult alloc] initWithJson:_order_result_json_];
                orderStr = orderResult.orderIds;
                [[XXAlertView currentAlertView] dismissAlertViewCompletion:^{
                    if(orderResult.cashNeedToPay > 0) {//需要支付现金
                        NSString *message = nil;
                        float prickHeight = 0.f;
                        if (orderResult.pointsPaid > 0) {
                            prickHeight = 385;
                            message = [NSString stringWithFormat:@"订单生成成功!您已支付%d米米;您还需要支付现金%.2f元,请选择支付方式。您也可以进入我的商品页面'未支付'进行支付",orderResult.pointsPaid, orderResult.cashNeedToPay];
                        }else{
                            prickHeight = 360;
                            message = [NSString stringWithFormat:@"订单生成成功!您需要支付现金%.2f元,请选择支付方式。您也可以进入我的商品页面'未支付'进行支付", orderResult.cashNeedToPay];
                        }
                        //微信支付
                        wxPayRequest.out_trade_no = orderResult.orderIds;
                        wxPayRequest.total_fee = [NSString stringWithFormat:@"%.0f",orderResult.cashNeedToPay * 100];
                        //  wxPayRequest.total_fee = [NSString stringWithFormat:@"%.0f",1.f];
                        wxPayRequest.traceid = orderResult.orderIds;
                        
                        //支付宝支付
                        aliPay.out_trade_no = orderResult.orderIds;
                        aliPay.total_fee = [NSString stringWithFormat:@"%.2f",orderResult.cashNeedToPay];
                        //                    aliPay.total_fee = [NSString stringWithFormat:@"%.2f",0.01f];
                        
                        NSMutableArray *categories = [NSMutableArray array];
                        [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"weixinPay" title:@"微信支付" imageName:@"wxpay"]];
                        [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"taobaoPay" title:@"支付宝支付" imageName:@"taobaopay"]];
                        [categories addObject:[[CategoryButtonItem alloc] initWithIdentifier:@"alterPay" title:@"以后支付" imageName:@"pay_after"]];
                        
                        CashPaymentTypePicker *modalView = [[CashPaymentTypePicker alloc] initWithSize:CGSizeMake(280, prickHeight)message:message buttonItems:categories];
                        modalView.btnItemDelegate = self;
                        //                    modalView.modalViewDelegate = self;
                        [modalView showInView:self.navigationController.view completion:nil];
                    }
                    else{  //不需要支付现金,购买成功！
                        YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 350) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"happy@2x" ofType:@"png"]] message:@"恭喜,购买成功!" buttonTitles:@[ @"立刻分享",@"确 定" ] cancelButtonIndex:0];
                        modal.shareDeletage = self;
                        modal.yoomidDelegate = self;
                        [modal showInView:self.navigationController.view completion:nil];
                        
                    }
                }];
                
#ifdef DEBUG
#endif
                if(_is_from_shopping_cart_) {
                    [[ShoppingCart myShoppingCart] clearAllSelectShoppingItems];
                }
                
                [[Account currentAccount] refresh];
            }

//        }];
        return;
    }
    [self submitOrdersFailure:resp];
}
//提交订单失败
- (void)submitOrdersFailure:(HttpResponse *)resp {
    NSString *errorMessage = @"出错啦!";
    if(1001 == resp.statusCode) {
        errorMessage = @"请求超时!";
    } else if(400 == resp.statusCode) {
        if(resp.contentType != nil && resp.body != nil && [resp.contentType rangeOfString:@"application/json" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSDictionary *_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
            if(_json_ != nil) {
                ReturnMessage *message = [[ReturnMessage alloc] initWithJson:_json_];
                errorMessage = [NSString stringWithFormat:@"对不起,%@!", message.message];
            }
        }
    } else if(403 == resp.statusCode) {
        errorMessage = @"请重新登录后再尝试!";
    } else {
        errorMessage = @"出错啦!";
    }
    [[XXAlertView currentAlertView] dismissAlertViewCompletion:^{
        YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 340) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cry@2x" ofType:@"png"]] message:errorMessage buttonTitles:@[ @"支付失败" ] cancelButtonIndex:0];
        [modal showInView:self.navigationController.view completion:nil];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteContactArray" object:nil];
}

#pragma mark- shareView deletage
-(void)showShare
{
    [self showShareTitle:nil text:@"居然是这个东东，好炫酷的样子~" imageName:@"icon80" imageUrl:nil contentUrl:nil];
}

#pragma mark - PayButton
- (void)categoryButtonItemDidSelectedWithIdentifier:(NSString *)identifier {
    PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:payOrderVC];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];

    
    if ([identifier isEqualToString:@"weixinPay"]) {
        payOrderVC.paymentMode = PaymentModeWXPay;
        payOrderVC.wxPayment = wxPayRequest;
        payOrderVC.index = 1;
        [self.navigationController pushViewController:payOrderVC animated:YES];
//        [self.navigationController presentViewController:navigationController animated:YES completion:^{
        
//        }];
    }else if ([identifier isEqualToString:@"taobaoPay"])
    {
        payOrderVC.paymentMode = PaymentModeAliPay;
        payOrderVC.aliPayment = aliPay;
        payOrderVC.index = 1;
        [self.navigationController pushViewController:payOrderVC animated:YES];
//        [self.navigationController presentViewController:navigationController animated:YES completion:^{
//        }];
    }else if ([identifier isEqualToString:@"alterPay"])
    {
        MerchandiseOrdersViewController *order = [[MerchandiseOrdersViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:order];
        [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
        [self.navigationController pushViewController:order animated:YES];
    }
}

//积分购买成功后，点击确定 代理
- (void)OKbtn{
    MerchandiseOrdersViewController *order = [[MerchandiseOrdersViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:order];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    [self.navigationController pushViewController:order animated:YES];
}

//- (void)submitAliPaySignSuccess:(HttpResponse *)resp {
//    if (resp.statusCode == 201) {
//        NSDictionary *sign_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
//        aliPay.sign = [sign_json_ objectForKey:@"sign"];
//        
//        NSMutableString * signStr = [NSMutableString string];
//        [signStr appendString:[aliPay toStrings]];
//        [signStr appendFormat:@"&sign=\"%@\"", aliPay.sign ? aliPay.sign : @""];
//        [signStr appendFormat:@"&sign_type=\"%@\"", @"RSA"];
//
//        [AlixLibService payOrder:signStr AndScheme:@"YoomidAliPay" seletor:@selector(paymentResult:) target:self];
//        return;
//    }
//    [self submitOrdersFailure:resp];
//}

-(void)paymentResult:(NSString *)resultd{
}

/*
//
- (void)submitPayRequestSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
        NSDictionary *access_token_json = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if (access_token_json != nil) {
            [wxPayRequest setAccess_tokens:access_token_json];
        }
        
        NSMutableDictionary *paramsD = [NSMutableDictionary dictionary];
        [paramsD setObject:wxPayRequest.wxAppId forKey:@"appid"];
        [paramsD setObject:wxPayRequest.noncestr forKey:@"noncestr"];
        [paramsD setObject:wxPayRequest.timestamp forKey:@"timestamp"];
        [paramsD setObject:wxPayRequest.traceid forKey:@"traceid"];
        [paramsD setObject:wxPayRequest.package_content forKey:@"package"];
        [paramsD setObject:wxPayRequest.app_signature forKey:@"app_signature"];
        [paramsD setObject:@"sha1" forKey:@"sign_method"];
//        NSLog(@"%@",paramsD);
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsD options:NSJSONWritingPrettyPrinted error: &error];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@",wxPayRequest.access_token];
        
        NSMutableURLRequest *mrequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        
        //设置提交方式
        [mrequest setHTTPMethod:@"POST"];
        //设置数据类型
        [mrequest addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        //设置编码
        [mrequest setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
        
        [mrequest setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mrequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *prepayid_json = [JsonUtil createDictionaryOrArrayFromJsonData:responseObject];
            long errCode = [[prepayid_json objectForKey:@"errcode"] longValue];
            if (errCode == 0) {
                NSLog(@"JSON: %@", prepayid_json);
                wxPayRequest.prepayid = [prepayid_json objectForKey:@"prepayid"];
                NSLog(@"prepay ID:%@",wxPayRequest.prepayid);
                
                NSDictionary *paySignDict = @{@"prepayid": wxPayRequest.prepayid,
                                              @"package": @"Sign=WXPay",
                                              @"noncestr": wxPayRequest.noncestr,
                                              @"timestamp": wxPayRequest.timestamp};
                
                MerchandiseService *service = [[MerchandiseService alloc] init];
                [service submitWXPaySign:[JsonUtil createJsonDataFromDictionary:paySignDict] target:self success:@selector(submitWXPaySignSuccess:) failure:@selector(submitOrdersFailure:) userInfo:nil];
            }else{
                [[XXAlertView currentAlertView] setMessage:@"打开微信支付失败!" forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[XXAlertView currentAlertView] setMessage:@"打开微信支付错误!" forType:AlertViewTypeFailed];
            [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        
        return;
    }
    [self submitOrdersFailure:resp];
}

- (void)submitWXPaySignSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 201) {
        [[XXAlertView currentAlertView] dismissAlertView];
        NSDictionary *sign_json = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSLog(@"JSON: %@", sign_json);
        
        wxPayRequest.sign = [sign_json objectForKey:@"sign"];
        
        PayReq *payRequest = [[PayReq alloc] init];
        payRequest.partnerId = @"1220874801";
        payRequest.prepayId = wxPayRequest.prepayid;
        payRequest.package = @"Sign=WXPay";
        payRequest.nonceStr = wxPayRequest.noncestr;
        payRequest.timeStamp = (UInt32)[wxPayRequest.timestamp longLongValue];
        payRequest.sign = wxPayRequest.sign;
        
        [WXApi safeSendReq:payRequest];
        return;
    }
    [self submitOrdersFailure:resp];
}

- (void)access_tokenFailure:(HttpResponse *)resp {
    
}
 */

@end
