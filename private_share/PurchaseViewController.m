//
//  PurchaseViewController.m
//  private_share
//
//  Created by Zhao yang on 7/25/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PurchaseViewController.h"
#import "ShoppingCart.h"
#import "ShoppingItemConfirmCell.h"
#import "ShoppingItemHeaderView.h"
#import "ShoppingItemConfirmFooterView.h"
#import "UIDevice+ScreenSize.h"
#import "ContactDisplayView.h"
#import "AddContactInfoViewController.h"
#import "HomeViewController.h"
#import "MerchandiseService.h"
#import "DiskCacheManager.h"
#import "OrderResult.h"
#import "ReturnMessage.h"

NSString * const ShoppingItemConfirmCellIdentifier   = @"ShoppingItemConfirmCellIdentifier";
NSString * const ShoppingItemConfirmHeaderIdentifier = @"ShoppingItemConfirmHeaderIdentifier";
NSString * const ShoppingItemConfirmFooterIdentifier = @"ShoppingItemConfirmFooterIdentifier";

@implementation PurchaseViewController {
    UICollectionView *_collectionView_;
    SettlementView *settlementView;
    ContactDisplayView *contactDisplayView;
    
    NSArray *_shopShoppingItemss_;
    
    NSString *_default_contact_id_;
    NSMutableArray *contacts;
    NSInteger _select;
    
    BOOL _is_from_shopping_cart_;
}

- (instancetype)initWithShopShoppingItemss:(NSArray *)shopShoppingItemss isFromShoppingCart:(BOOL)isFromShoppingCart {
    self = [super init];
    if(self) {
        _shopShoppingItemss_ = shopShoppingItemss;
        _is_from_shopping_cart_ = isFromShoppingCart;
        _select = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContactArray:) name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteContactArray:) name:@"deleteContactArray" object:nil];
    
    self.title = NSLocalizedString(@"confirm_order", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];

    settlementView = [[SettlementView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 60, self.view.bounds.size.width, 60)];
    settlementView.delegate = self;
    [settlementView setSelectButtonHidden];
    [self.view addSubview:settlementView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView_ = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44) - 60) collectionViewLayout:layout];
    _collectionView_.backgroundColor = [UIColor clearColor];
    [_collectionView_ registerClass:[ShoppingItemConfirmCell class] forCellWithReuseIdentifier:ShoppingItemConfirmCellIdentifier];
    
    [_collectionView_ registerClass:[ShoppingItemConfirmFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ShoppingItemConfirmFooterIdentifier];
    [_collectionView_ registerClass:[ShoppingItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ShoppingItemConfirmHeaderIdentifier];
    
    _collectionView_.alwaysBounceVertical = YES;
    _collectionView_.delegate = self;
    _collectionView_.dataSource = self;
    [self.view addSubview:_collectionView_];
    
    contactDisplayView = [[ContactDisplayView alloc] initWithFrame:
                          CGRectMake(0, -kContactDisplayViewHeight, [UIScreen mainScreen].bounds.size.width, 0) contact:[ShoppingCart myShoppingCart].orderContact];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushContactInfo:)];
    [contactDisplayView addGestureRecognizer:tapGesture];
    
    _collectionView_.contentInset = UIEdgeInsetsMake(contactDisplayView.bounds.size.height, 0, 0, 0);
    [_collectionView_ addSubview:contactDisplayView];
    
    if(_is_from_shopping_cart_) {
        [self setRightPanDismissWithTransitionStyle];
    } else {
        self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    }
    
    [self refreshSettlementView];
    [self mayGetContactInfo];
}

- (void)deleteContactArray:(NSNotification*)notif {
    contacts = notif.object;
    if (contacts.count > 0) {
        _select = 0;
        [ShoppingCart myShoppingCart].orderContact = [contacts objectAtIndex:0];
    }
    [contactDisplayView setCurrentContact:[ShoppingCart myShoppingCart].orderContact];
}

- (void)updateContactArray:(NSNotification*)notif {
    contacts = notif.object;
    [ShoppingCart myShoppingCart].orderContact = [contacts objectAtIndex:_select];
    [contactDisplayView setCurrentContact:[ShoppingCart myShoppingCart].orderContact];
}

- (void)mayGetContactInfo {
    BOOL isExpired;
    NSArray *_contacts_ = [[DiskCacheManager manager] contacts:&isExpired];
    
    if(_contacts_ != nil) {
        contacts = [NSMutableArray arrayWithArray:_contacts_];
        [contactDisplayView setCurrentContact:[self defaultContact]];
        [ShoppingCart myShoppingCart].orderContact = [self defaultContact];
    }
    
    if(isExpired || _contacts_ == nil) {
        [self getContactInfo];
    }
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
    } else {
        [self handleFailureHttpResponse:resp];
    }
}

- (Contact *)defaultContact {
    _default_contact_id_ = nil;
    if(contacts == nil || contacts.count == 0) return nil;
    
    for(int i=0; i<contacts.count; i++) {
        Contact *contact = [contacts objectAtIndex:i];
        if(contact.isDefault) {
            _default_contact_id_ = contact.identifier;
            return contact;
        }
    }
    return nil;
}

- (void)pushContactInfo:(id)sender {
    SelectContactAddressViewController *selectContactAddress = [[SelectContactAddressViewController alloc]initWithContactInfo:contacts selected:_select];
    selectContactAddress.delegate = self;
    [self.navigationController pushViewController:selectContactAddress animated:YES];
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

-(void)contactInfo:(Contact *)contact selectd:(NSInteger)select {
    [ShoppingCart myShoppingCart].orderContact = contact;
    [contactDisplayView setCurrentContact:[ShoppingCart myShoppingCart].orderContact];
    _select = select;
}

#pragma mark -
#pragma mark 

- (void)popViewController {
    if(_is_from_shopping_cart_) {
        [self rightPopViewControllerAnimated:YES];
    } else {
        [self rightDismissViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark 

- (void)modalViewDidClosed:(ModalView *)modalView {
    [self rightPopViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _shopShoppingItemss_ == nil ? 0 : _shopShoppingItemss_.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ShopShoppingItems *ssi = [_shopShoppingItemss_ objectAtIndex:section];
    return ssi.selectShoppingItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopShoppingItems *ssi = [_shopShoppingItemss_ objectAtIndex:indexPath.section];
    ShoppingItem *si = [ssi.selectShoppingItems objectAtIndex:indexPath.row];
    ShoppingItemConfirmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShoppingItemConfirmCellIdentifier forIndexPath:indexPath];
    cell.shoppingCartViewController = self;
    cell.shoppingItem = si;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopShoppingItems *ssi = [_shopShoppingItemss_ objectAtIndex:indexPath.section];
    CGFloat height = [ShoppingItemConfirmCell calcCellHeightWithShoppingItem:[ssi.selectShoppingItems objectAtIndex:indexPath.row]];
    return CGSizeMake(self.view.bounds.size.width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 300);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 44);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ShopShoppingItems *shopShoppingItems = [_shopShoppingItemss_ objectAtIndex:indexPath.section];
    if(UICollectionElementKindSectionFooter == kind) {
        ShoppingItemConfirmFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ShoppingItemConfirmFooterIdentifier forIndexPath:indexPath];
        footerView.shopShoppingItems = shopShoppingItems;
        footerView.purchaseViewController = self;
        return footerView;
    } else {
        ShoppingItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ShoppingItemConfirmHeaderIdentifier forIndexPath:indexPath];
        [headerView setSelectButtonHidden];
        headerView.shopId = shopShoppingItems.shopID;
        return headerView;
    }
    return nil;
}

- (void)purchaseButtonPressed:(id)sender {
    if([ShoppingCart myShoppingCart].orderContact.isEmpty) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"contact_required", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    NSMutableArray *ordersToSubmit = [NSMutableArray array];
    for(ShopShoppingItems *ssi in _shopShoppingItemss_) {
        NSMutableArray *shoppingItems = [NSMutableArray array];
        for(ShoppingItem *si in ssi.selectShoppingItems) {
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
                                    @"contactId" : [ShoppingCart myShoppingCart].orderContact.identifier,
                                    @"remark" : (ssi.remark == nil ? @"" : ssi.remark),
                                    },
                                    @"shoppingItems" : shoppingItems
        };
        [ordersToSubmit addObject:shopOrder];
    }
    
#ifdef DEBUG
    [JsonUtil printArrayAsJsonFormat:ordersToSubmit];
#endif
    
    [[XXAlertView currentAlertView] setMessage:@"正在提交" forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    MerchandiseService *service =  [[MerchandiseService alloc] init];
    [service submitOrders:[JsonUtil createJsonDataFromArray:ordersToSubmit] target:self success:@selector(submitOrdersSuccess:) failure:@selector(submitOrdersFailure:) userInfo:nil];
}

- (void)submitOrdersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {

        NSDictionary *_order_result_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(_order_result_json_ != nil) {
            OrderResult *orderResult = [[OrderResult alloc] initWithJson:_order_result_json_];
            if(orderResult.cashNeedToPay > 0) {
                
            }
#ifdef DEBUG
#endif
            if(_is_from_shopping_cart_) {
                [[ShoppingCart myShoppingCart] clearAllSelectShoppingItems];
            }
            
            [[XXAlertView currentAlertView] dismissAlertViewCompletion:^{
                YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 350) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"happy@2x" ofType:@"png"]] message:@"恭喜,购买成功!" buttonTitles:@[ @"支付成功" ] cancelButtonIndex:0];
                modal.modalViewDelegate = self;
                [modal showInView:self.navigationController.view completion:nil];
            }];
        }
        return;
    }
    [self submitOrdersFailure:resp];
}

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
        YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 330) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cry@2x" ofType:@"png"]] message:errorMessage buttonTitles:@[ @"支付失败" ] cancelButtonIndex:0];
        [modal showInView:self.navigationController.view completion:nil];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateContactArray" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteContactArray" object:nil];
}

@end
