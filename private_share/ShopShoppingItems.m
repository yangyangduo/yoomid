//
//  ShopShoppingItems.m
//  private_share
//
//  Created by Zhao yang on 6/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShopShoppingItems.h"

@implementation ShopShoppingItems

@synthesize shopID;
@synthesize shopName;
@synthesize remark;
@synthesize postPaymentType;
@synthesize shoppingItems = _shoppingItems_;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.postPaymentType = PaymentTypePoints;
    }
    return self;
}

- (NSArray *)shoppingItemsWithPaymentType:(PaymentType)paymentType {
    if(PaymentTypeAll == paymentType) {
        return [NSArray arrayWithArray:self.shoppingItems];
    } else {
        NSMutableArray *items = [NSMutableArray array];
        for(int i=0; i<self.shoppingItems.count; i++) {
            ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
            if(paymentType == item.paymentType) {
                [items addObject:item];
            }
        }
        return items;
    }
}

- (NSArray *)shoppingItemsWithMerchandiseId:(NSString *)merchandiseId {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if(merchandiseId == nil) return items;
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
        if(item.merchandise != nil
           && item.merchandise.identifier != nil
           && [item.merchandise.identifier isEqualToString:merchandiseId]) {
            [items addObject:item];
        }
    }
    return items;
}

- (NSArray *)shoppingItemsWithMerchandiseId:(NSString *)merchandiseId paymentType:(PaymentType)paymentType {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if(merchandiseId == nil) return items;
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
        if(item.merchandise != nil
           && item.merchandise.identifier != nil
           && [item.merchandise.identifier isEqualToString:merchandiseId]
           && paymentType == item.paymentType) {
            [items addObject:item];
        }
    }
    return items;
}

- (ShoppingItem *)shoppingItemWithMerchandiseId:(NSString *)merchandiseId paymentType:(PaymentType)paymentType properties:(NSArray *)properties {
    if(merchandiseId == nil) return nil;
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
        if(item.merchandise != nil
           && item.merchandise.identifier != nil
           && [item.merchandise.identifier isEqualToString:merchandiseId]
           && paymentType == item.paymentType
           && [[self merchandisePropertiesAsString:properties] isEqualToString:[item propertiesAsString]]) {
            return item;
        }
    }
    return nil;
}

- (NSArray *)selectShoppingItems {
    NSMutableArray *selectItems = [NSMutableArray array];
    for(ShoppingItem *si in self.shoppingItems) {
        if(si.selected) {
            [selectItems addObject:si];
        }
    }
    return selectItems;
}

- (Payment *)totalPayment {
    Payment *payment = [Payment emptyPayment];
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *shoppingItem = [self.shoppingItems objectAtIndex:i];
        [payment addWithPayment:shoppingItem.payment];
    }
    return payment;
}

- (Payment *)totalSelectPayment {
    Payment *payment = [Payment emptyPayment];
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *shoppingItem = [self.shoppingItems objectAtIndex:i];
        if(shoppingItem.selected) {
            [payment addWithPayment:shoppingItem.payment];
        }
    }
    return payment;
}

- (Payment *)totalSelectPaymentWithPostPay {
    Payment *payment = [Payment emptyPayment];
    if(PaymentTypePoints == self.postPaymentType) {
        payment = [[Payment alloc] initWithPoints:300 cash:0];
    } else if(PaymentTypeCash == self.postPaymentType) {
        payment = [[Payment alloc] initWithPoints:0 cash:5.f];
    }
    
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *shoppingItem = [self.shoppingItems objectAtIndex:i];
        if(shoppingItem.selected) {
            [payment addWithPayment:shoppingItem.payment];
        }
    }
    return payment;
}

- (void)clearEmptyShoppingItems {
    NSMutableArray *removedList = [NSMutableArray array];
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
        if(item.number == 0) {
            [removedList addObject:item];
        }
    }
    if(removedList.count != 0) {
        [self.shoppingItems removeObjectsInArray:removedList];
    }
}

- (BOOL)hasMerchandises {
    return (self.shoppingItems != nil) && (self.shoppingItems.count > 0);
}

- (NSMutableArray *)shoppingItems {
    if(_shoppingItems_ == nil) {
        _shoppingItems_ = [NSMutableArray array];
    }
    return _shoppingItems_;
}

- (NSString *)merchandisePropertiesAsString:(NSArray *)properties {
    if(properties == nil || properties.count == 0) {
        return @"";
    }
    NSMutableString *string = [NSMutableString string];
    for(int i=0; i<properties.count; i++) {
        NSDictionary *property = [properties objectAtIndex:i];
        [string appendString:[property objectForKey:@"name"]];
        [string appendString:@":"];
        [string appendString:[property objectForKey:@"value"]];
        if(i != properties.count - 1) {
            [string appendString:@";"];
        }
    }
    return string;
}

@end
