//
//  ShoppingItemsChangedEvent.h
//  private_share
//
//  Created by Zhao yang on 6/21/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "XXEvent.h"
#import "Payment.h"

@interface ShoppingItemsChangedEvent : XXEvent

@property (nonatomic, strong) Payment *totalPayment;

@end
