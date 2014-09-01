//
//  DiskCacheManager.h
//  private_share
//
//  Created by Zhao yang on 6/19/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonEntity.h"
#import "TaskCategory.h"
#import "Contact.h"
#import "Profile.h"
#import "PointsOrder.h"

extern NSString * const YOOMID_DIRECTORY_NAME;
extern NSTimeInterval const CACHE_DATA_EXPIRED_MINUTES_INTERVAL;

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

- (NSArray *)activities:(BOOL *)isExpired;
- (NSArray *)merchandises:(BOOL *)isExpired;
- (NSArray *)taskCategories:(BOOL *)isExpired;

- (void)setActivities:(NSArray *)activities;
- (void)setMerchandises:(NSArray *)merchandises;
- (void)setTaskCategories:(NSArray *)taskCategories;


/**
 * user data source
 * for current user
 */

- (Profile *)profile:(BOOL *)isExpired;
- (NSArray *)pointsOrdersWithPointsOrderType:(PointsOrderType)pointsOrderType isExpired:(BOOL *)isExpired;

- (void)setProfile:(Profile *)profile;
- (void)setPointsOrders:(NSArray *)pointsOrders pointsOrderType:(PointsOrderType)pointsOrderType;

@end


@interface CacheData : BaseModel

@property (nonatomic, strong) id data; 
@property (nonatomic, strong) NSDate *lastRefreshTime;

- (BOOL)isExpired;

@end


