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
@synthesize maximumPeoples;
@synthesize address;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json != nil) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.name = [json noNilStringForKey:@"name"];
        self.shortDescription = [json noNilStringForKey:@"shortDescrition"];
        self.category = [json noNilStringForKey:@"category"];
        self.points = [json numberForKey:@"points"].integerValue;
        self.exchangeCount = [json numberForKey:@"exchangeCount"].integerValue;
        self.createTime = [json numberForKey:@"createTime"].doubleValue;
        self.returnPoints = [json numberForKey:@"returnPoints"].integerValue;
        self.imageUrls = [json arrayForKey:@"imageUrls"];
        
        self.maximumPeoples = [json numberForKey:@"maximumPeoples"].integerValue;
        self.follows = [json numberForKey:@"follows"].longValue;
        self.startTime = [json dateWithMillisecondsForKey:@"startTime"];
        self.endTime = [json dateWithMillisecondsForKey:@"endTime"];
        self.buyStartTime = [json dateWithMillisecondsForKey:@"buyStartTime"];
        self.buyEndTime = [json dateWithMillisecondsForKey:@"buyEndTime"];
        NSDictionary *_address_ = [json dictionaryForKey:@"address"];
        if(_address_ != nil) {
            self.address = [[Address alloc] initWithJson:_address_];
        }
        
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
    }
    return self;
}

- (NSString *)firstImageUrl {
    if(self.imageUrls == nil || self.imageUrls.count == 0) return nil;
    return [self.imageUrls objectAtIndex:0];
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *dictionary = [super toJson];
    [dictionary setMayBlankString:self.identifier forKey:@"id"];
    [dictionary setMayBlankString:self.name forKey:@"name"];
    [dictionary setMayBlankString:self.shortDescription forKey:@"shortDescrition"];
    [dictionary setMayBlankString:self.category forKey:@"category"];
    [dictionary setInteger:self.points forKey:@"points"];
    [dictionary setInteger:self.exchangeCount forKey:@"exchangeCount"];
    [dictionary setInteger:self.returnPoints forKey:@"returnPoints"];
    [dictionary setDouble:self.createTime forKey:@"createTime"];
    [dictionary setNoNilObject:self.imageUrls forKey:@"imageUrls"];
    return dictionary;
}

@end
