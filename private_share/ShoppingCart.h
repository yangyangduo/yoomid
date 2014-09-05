//
//  ShoppingCart.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopShoppingItems.h"
#import "Contact.h"

typedef NS_ENUM(NSUInteger, CashPaymentType) {
    CashPaymentTypeNone,
    CashPaymentTypeAlipay,
    CashPaymentTypeWechatPay,
    CashPaymentTypeUnionPay
};

@interface ShoppingCart : NSObject

@property (nonatomic, strong) Contact *orderContact;

+ (instancetype)myShoppingCart;

- (Payment *)totalPayment;
- (Payment *)totalSelectPayment;

- (ShopShoppingItems *)shopShoppingItemsWithShopID:(NSString *)shopID;

- (void)putMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType properties:(NSArray *)properties;
- (void)setMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType properties:(NSArray *)properties;

- (NSArray *)selectShopShoppingItemss;

- (void)clearEmptyShoppingItems;
- (void)clearShoppingItemss;
- (void)clearMyShoppingCart;
- (void)clearContactInfo;

- (BOOL)hasMerchandises;
- (BOOL)hasMerchandisesWithShopID:(NSString *)shopID;

- (BOOL)allSelect;
- (void)setAllSelect:(BOOL)select;

- (BOOL)selectWithShopId:(NSString *)shopId;
- (void)setSelect:(BOOL)select forShopId:(NSString *)shopId;

- (void)setSelect:(BOOL)select forShoppingItem:(ShoppingItem *)shoppingItem;

- (NSMutableArray *)shopShoppingItemss;

- (void)publishEvent;
- (void)publishSelectPropertyChangedEvent;

- (NSMutableDictionary *)toDictionaryWithShopID:(NSString *)shopID;
- (void)printShoppingCartForHentreStoreAsJson;

@end
