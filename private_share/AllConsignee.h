//
//  AllConsignee.h
//  private_share
//
//  Created by 曹大为 on 14/11/13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Consignee.h"

/*
 * 当前用户所有 收货人信息
 */
@interface AllConsignee : NSObject

@property (nonatomic, strong) NSMutableArray *allConsignee;
+ (instancetype)myAllConsignee;
- (BOOL) isEmpty;
- (void) getContact;
- (NSMutableArray *) consignee;
- (Consignee *) currentConsignee;
- (void) setCurrentConsignee:(NSInteger)index;

- (void) deleteConsigneeWithID:(NSString *)consigneeID;
- (void) modifyConsigneeWithID:(Consignee *)consignee;
- (void) setDefaultConsigneeWithID:(NSString *)consigneeID;
@end
