//
//  Merchandise.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "MerchandiseProperty.h"

@interface Merchandise : BaseModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger merchandiseType;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, assign) NSInteger returnPoints;

@property (nonatomic, assign) NSInteger follows;
@property (nonatomic, assign) NSInteger exchangeCount;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *buyStartTime;
@property (nonatomic, strong) NSDate *buyEndTime;

@property (nonatomic, strong) NSDate *createTime;

@property (nonatomic, assign) double price;
@property (nonatomic, assign) double originalPrice;

//首页广告轮播，用来判断店铺模板类型：1、单列大图，小吉推荐模式  2、单列小图，全部商品列表模式
@property (nonatomic, strong) NSString *viewType;

// 1 : 1 其他
- (NSString *)firstImageUrl;
// 3 : 4 小吉推荐
- (NSString *)secondImageUrl;

- (BOOL)isActivity;

@end