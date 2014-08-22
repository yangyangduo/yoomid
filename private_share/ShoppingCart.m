//
//  ShoppingCart.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCart.h"
#import "JsonUtil.h"
#import "Account.h"
#import "PointsOrderService.h"
#import "XXEventSubscriptionPublisher.h"
#import "ShoppingItemsChangedEvent.h"
#import "ShoppingItemSelectPropertyChangedEvent.h"

@implementation ShoppingCart {
    NSMutableArray *shopShoppingItemss;
}

@synthesize orderContact = _orderContact_;

+ (instancetype)myShoppingCart {
    static dispatch_once_t onceToken;
    static ShoppingCart *shoppingCart;
    dispatch_once(&onceToken, ^{
        shoppingCart = [[ShoppingCart alloc] init];
    });
    return shoppingCart;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        shopShoppingItemss = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)selectShopShoppingItemss {
    NSMutableArray *selectShopShoppingItemss = [NSMutableArray array];
    for(ShopShoppingItems *ssi in self.shopShoppingItemss) {
        if(ssi.selectShoppingItems.count > 0) {
            [selectShopShoppingItemss addObject:ssi];
        }
    }
    return selectShopShoppingItemss;
}

- (ShopShoppingItems *)shopShoppingItemsWithShopID:(NSString *)shopID {
    if(shopID == nil) return nil;
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        if([ssi.shopID isEqualToString:shopID]) {
            return ssi;
        }
    }
    return nil;
}

- (void)putMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType properties:(NSArray *)properties {
    if(number == 0 || merchandise == nil || shopID == nil) return;
    
    BOOL needAddShop = NO;
    ShopShoppingItems *shopShoppingItems = [self shopShoppingItemsWithShopID:shopID];
    
    // no shop in shopping cart, create a shop
    if(shopShoppingItems == nil) {
        shopShoppingItems = [[ShopShoppingItems alloc] init];
        shopShoppingItems.shopID = shopID;
        needAddShop = YES;
    }
    
    ShoppingItem *item = [shopShoppingItems shoppingItemWithMerchandiseId:merchandise.identifier paymentType:paymentType properties:properties];
    
    // exists merchandise
    if(item != nil) {
        item.number += number;
        [self publishEvent];
        return;
    }
    
    // new merchandise
    ShoppingItem *newItem = [[ShoppingItem alloc] init];
    newItem.merchandise = merchandise;
    newItem.number = number;
    newItem.paymentType = paymentType;
    newItem.properties = properties;
    newItem.shopId = shopID;
    
    [shopShoppingItems.shoppingItems addObject:newItem];
    if(needAddShop) {
        [shopShoppingItemss addObject:shopShoppingItems];
    }
    
    [self publishEvent];
}

- (void)setMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType properties:(NSArray *)properties {
    if(merchandise == nil) return;
    
    BOOL needAddShop = NO;
    ShopShoppingItems *shopShoppingItems = [self shopShoppingItemsWithShopID:shopID];
    
    if(shopShoppingItems == nil) {
        shopShoppingItems = [[ShopShoppingItems alloc] init];
        shopShoppingItems.shopID = shopID;
        needAddShop = YES;
    }
    
    ShoppingItem *item = [shopShoppingItems shoppingItemWithMerchandiseId:merchandise.identifier paymentType:paymentType properties:properties];
    if(item != nil) {
        if(number == 0) {
            [shopShoppingItems.shoppingItems removeObject:item];
            [self publishEvent];
            return;
        }
        item.number = number;
        [self publishEvent];
        return;
    }
    
    // 新增的商品为0 忽略
    if(number == 0) return;
    
    ShoppingItem *newItem = [[ShoppingItem alloc] init];
    newItem.merchandise = merchandise;
    newItem.number = number;
    newItem.paymentType = paymentType;
    newItem.properties = properties;
    newItem.shopId = shopID;
    
    [shopShoppingItems.shoppingItems addObject:newItem];
    if(needAddShop) {
        [shopShoppingItemss addObject:shopShoppingItems];
    }
    [self publishEvent];
    return;
}

- (void)clearEmptyShoppingItems {
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        [ssi clearEmptyShoppingItems];
    }
}

- (void)clearContactInfo {
    _orderContact_ = [[Contact alloc] init];
}

- (void)clearShoppingItemss {
    [shopShoppingItemss removeAllObjects];
}

- (void)clearMyShoppingCart {
    [self clearShoppingItemss];
    _orderContact_ = [[Contact alloc] init];
}

- (BOOL)hasMerchandises {
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        if(ssi.hasMerchandises) return YES;
    }
    return NO;
}

- (BOOL)hasMerchandisesWithShopID:(NSString *)shopID {
    ShopShoppingItems *ssi = [self shopShoppingItemsWithShopID:shopID];
    if(ssi == nil) return NO;
    return ssi.hasMerchandises;
}

- (Payment *)totalPayment {
    Payment *payment = [Payment emptyPayment];
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        [payment addWithPayment:ssi.totalPayment];
    }
    return payment;
}

- (Payment *)totalSelectPayment {
    Payment *payment = [Payment emptyPayment];
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        [payment addWithPayment:ssi.totalSelectPayment];
    }
    return payment;
}

- (NSMutableDictionary *)toDictionaryWithShopID:(NSString *)shopID {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    ShopShoppingItems *ssi = [self shopShoppingItemsWithShopID:shopID];
    if(ssi == nil) return dic;
    NSMutableArray *merchandiseLists = [NSMutableArray array];
    for(int i=0; i<ssi.shoppingItems.count; i++) {
        ShoppingItem *item = [ssi.shoppingItems objectAtIndex:i];
        [merchandiseLists addObject:[item toDictionary]];
    }
    [dic setNoNilObject:merchandiseLists forKey:@"merchandiseLists"];
    [dic setMayBlankString:kHentreStoreID forKey:@"shopId"];
    [dic setNoNilObject:[self.orderContact toDictionary]  forKey:@"contactInfo"];
    return dic;
}

- (void)setSelect:(BOOL)select forShoppingItem:(ShoppingItem *)shoppingItem {
    shoppingItem.selected = select;
    
    ShopShoppingItems *ssi = [self shopShoppingItemsWithShopID:shoppingItem.shopId];
    BOOL allSelect = YES;
    for(ShoppingItem *si in ssi.shoppingItems) {
        if(!si.selected) {
            allSelect = NO;
            break;
        }
    }
    
    [self publishSelectPropertyChangedEvent];
}

- (void)setSelect:(BOOL)select forShopId:(NSString *)shopId {
    ShopShoppingItems *ssi = [self shopShoppingItemsWithShopID:shopId];
    if(ssi != nil) {
        for(ShoppingItem *si in ssi.shoppingItems) {
            si.selected = select;
        }
    }
    [self publishSelectPropertyChangedEvent];
}

- (BOOL)selectWithShopId:(NSString *)shopId {
    ShopShoppingItems *ssi = [self shopShoppingItemsWithShopID:shopId];
    BOOL allSelect = YES;
    for(ShoppingItem *si in ssi.shoppingItems) {
        if(!si.selected) {
            allSelect = NO;
            break;
        }
    }
    return allSelect;
}

- (void)setAllSelect:(BOOL)select {
    for(ShopShoppingItems *ssi in self.shopShoppingItemss) {
        for(ShoppingItem *si in ssi.shoppingItems) {
            si.selected = select;
        }
    }
    [self publishSelectPropertyChangedEvent];
}

- (BOOL)allSelect {
    for(ShopShoppingItems *ssi in self.shopShoppingItemss) {
        for(ShoppingItem *si in ssi.shoppingItems) {
            if(!si.selected) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)printShoppingCartForHentreStoreAsJson {
    [JsonUtil printDictionaryAsJsonFormat:[self toDictionaryWithShopID:kHentreStoreID]];
}

- (void)publishEvent {
    ShoppingItemsChangedEvent *event = [[ShoppingItemsChangedEvent alloc] init];
    event.totalPayment = [self.totalPayment copy];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
}

- (void)publishSelectPropertyChangedEvent {
    ShoppingItemSelectPropertyChangedEvent *event = [[ShoppingItemSelectPropertyChangedEvent alloc] init];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
}

- (NSMutableArray *)shopShoppingItemss {
    return shopShoppingItemss;
}

#pragma mark -
#pragma mark Getter and setter's

- (Contact *)orderContact {
    if(_orderContact_ == nil) {
        _orderContact_ = [[Contact alloc] init];
    }
    return _orderContact_;
}

@end
