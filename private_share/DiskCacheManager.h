//
//  DiskCacheManager.h
//  private_share
//
//  Created by Zhao yang on 6/19/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"
#import "Profile.h"
#import "PointsOrder.h"

extern NSString * const YOOMID_DIRECTORY_NAME;

@interface DiskCacheManager : NSObject

/**
 * singleton
 */
+ (DiskCacheManager *)manager;

/**
 *
 */
- (void)serveForAccount:(NSString *)account;

/**
 * public data source
 * for all users
 */

+ (NSArray *)activities:(BOOL)isExpired;
+ (NSArray *)merchandises:(BOOL)isExpired;
+ (NSArray *)taskCategories:(BOOL)isExpired;


/**
 * user data source
 * for current user
 */

- (Profile *)profile:(BOOL)isExpired;
- (NSArray *)pointsOrdersWithPointsOrderType:(PointsOrderType)pointsOrderType isExpired:(BOOL *)isExpired;

@end
