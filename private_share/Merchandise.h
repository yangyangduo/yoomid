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
#import "Address.h"

@interface Merchandise : BaseModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger exchangeCount;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, strong) NSString *shortDescription;

@property (nonatomic, assign) NSInteger returnPoints;

@property (nonatomic, assign) long follows;
@property (nonatomic, assign) NSInteger maximumPeoples;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *buyStartTime;
@property (nonatomic, strong) NSDate *buyEndTime;
@property (nonatomic, strong) Address *address;

@property (nonatomic, strong) NSArray *properties;

- (NSString *)firstImageUrl;

@end