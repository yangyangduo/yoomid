//
//  Merchandise.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Merchandise.h"

@implementation Merchandise {
}

@synthesize identifier;
@synthesize shopId;
@synthesize name;
@synthesize imageUrls;
@synthesize category;
@synthesize points;
@synthesize exchangeCount;
@synthesize createTime;
@synthesize shortDescription;
@synthesize returnPoints;

@synthesize properties;

@synthesize follows;
@synthesize startTime;
@synthesize endTime;
@synthesize buyStartTime;
@synthesize buyEndTime;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json != nil) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.shopId = [json noNilStringForKey:@"shopId"];
        self.name = [json noNilStringForKey:@"name"];
        self.shortDescription = [json noNilStringForKey:@"shortDescrition"];
        self.category = [json noNilStringForKey:@"category"];
        self.points = [json numberForKey:@"points"].integerValue;
        self.returnPoints = [json numberForKey:@"returnPoints"].integerValue;
        self.imageUrls = [json arrayForKey:@"imageUrls"];
        
        NSMutableArray *propers = [NSMutableArray array];
        NSArray *_properties_ = [json arrayForKey:@"properties"];
        if(_properties_ != nil) {
            for(int i=0; i<_properties_.count; i++) {
                NSDictionary *property = [_properties_ objectAtIndex:i];
                MerchandiseProperty *mProperty = [[MerchandiseProperty alloc] initWithJson:property];
                [propers addObject:mProperty];
            }
        }
        self.properties = propers;
        
        self.follows = [json numberForKey:@"follows"].integerValue;
        self.exchangeCount = [json numberForKey:@"exchangeCount"].integerValue;
        
        self.startTime = [json dateWithMillisecondsForKey:@"startTime"];
        self.endTime = [json dateWithMillisecondsForKey:@"endTime"];
        self.buyStartTime = [json dateWithMillisecondsForKey:@"buyStartTime"];
        self.buyEndTime = [json dateWithMillisecondsForKey:@"buyEndTime"];
        
        self.createTime = [json dateWithMillisecondsForKey:@"createTime"];
    }
    return self;
}

- (NSString *)firstImageUrl {
    if(self.imageUrls == nil || self.imageUrls.count == 0) return nil;
    return [self.imageUrls objectAtIndex:0];
}

- (NSString *)secondImageUrl {
    if(self.imageUrls != nil && self.imageUrls.count >= 2) {
        return [self.imageUrls objectAtIndex:1];
    }
    return [self firstImageUrl];
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.identifier forKey:@"id"];
    [json setMayBlankString:self.shopId forKey:@"shopId"];
    [json setMayBlankString:self.name forKey:@"name"];
    [json setMayBlankString:self.shortDescription forKey:@"shortDescrition"];
    [json setMayBlankString:self.category forKey:@"category"];
    [json setInteger:self.points forKey:@"points"];
    [json setInteger:self.returnPoints forKey:@"returnPoints"];
    [json setNoNilObject:self.imageUrls forKey:@"imageUrls"];
    
    NSMutableArray *propertiesJsonArray = [NSMutableArray array];
    if(self.properties != nil) {
        for(int i=0; i<self.properties.count; i++) {
            MerchandiseProperty *property = [self.properties objectAtIndex:i];
            [propertiesJsonArray addObject:[property toJson]];
        }
    }
    [json setNoNilObject:propertiesJsonArray forKey:@"properties"];
    
    [json setInteger:self.follows forKey:@"follows"];
    [json setInteger:self.exchangeCount forKey:@"exchangeCount"];
    
    [json setDateWithMilliseconds:self.startTime forKey:@"startTime"];
    [json setDateWithMilliseconds:self.endTime forKey:@"endTime"];
    [json setDateWithMilliseconds:self.buyStartTime forKey:@"buyStartTime"];
    [json setDateWithMilliseconds:self.buyEndTime forKey:@"buyEndTime"];
    [json setDateWithMilliseconds:self.createTime forKey:@"createTime"];
    
    return json;
}

@end
