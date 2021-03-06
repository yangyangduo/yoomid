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
#import "PointsOrder.h"
#import "Merchandise.h"
#import "RowView.h"

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
- (NSArray *)recommendedMerchandises:(BOOL *)isExpired;
- (NSArray *)taskCategories:(BOOL *)isExpired;
- (NSArray *)completedTaskIds;
- (NSArray *)merchandisesTemplate:(BOOL *)isExpired;

- (void)setActivities:(NSArray *)activities;
- (void)setMerchandises:(NSArray *)merchandises;
- (void)setRecommendedMerchandises:(NSArray *)merchandises;
- (void)setTaskCategories:(NSArray *)taskCategories;
- (void)setCompletedTaskIds:(NSArray *)taskIds;
- (void)setMerchandisesTemplate:(NSArray *)merchandise_template;

/**
 * user data source
 * for current user
 */

- (NSArray *)contacts:(BOOL *)isExpired;
- (NSArray *)pointsOrdersWithPointsOrderType:(PointsOrderType)pointsOrderType isExpired:(BOOL *)isExpired;
- (NSArray *)merchandisesIds;
- (NSArray *)userInfo;
- (NSArray *)activitiesIds;

- (void)setContacts:(NSArray *)contacts;
- (void)setPointsOrders:(NSArray *)pointsOrders pointsOrderType:(PointsOrderType)pointsOrderType;
- (void)setMerchandisesIds:(NSArray *)merchandisesIds;
- (void)setUserInfo:(NSArray *)userInfo;
- (void)setActivitiesIds:(NSArray *)activitieIds;

@end


@interface CacheData : BaseModel

@property (nonatomic, strong) id data; 
@property (nonatomic, strong) NSDate *lastRefreshTime;

- (BOOL)isExpired;

@end


