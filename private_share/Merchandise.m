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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self && dictionary != nil) {
        self.identifier = [dictionary noNilStringForKey:@"id"];
        self.name = [dictionary noNilStringForKey:@"name"];
        self.shortDescription = [dictionary noNilStringForKey:@"shortDescrition"];
        self.category = [dictionary noNilStringForKey:@"category"];
        self.points = [dictionary numberForKey:@"points"].integerValue;
        self.exchangeCount = [dictionary numberForKey:@"exchangeCount"].integerValue;
        self.createTime = [dictionary numberForKey:@"createTime"].doubleValue;
        self.returnPoints = [dictionary numberForKey:@"returnPoints"].integerValue;
        self.imageUrls = [dictionary arrayForKey:@"imageUrls"];
        
        self.maximumPeoples = [dictionary numberForKey:@"maximumPeoples"].integerValue;
        self.follows = [dictionary numberForKey:@"follows"].longValue;
        self.startTime = [dictionary dateWithMillisecondsForKey:@"startTime"];
        self.endTime = [dictionary dateWithMillisecondsForKey:@"endTime"];
        self.buyStartTime = [dictionary dateWithMillisecondsForKey:@"buyStartTime"];
        self.buyEndTime = [dictionary dateWithMillisecondsForKey:@"buyEndTime"];
        NSDictionary *_address_ = [dictionary dictionaryForKey:@"address"];
        if(_address_ != nil) {
            self.address = [[Address alloc] initWithDictionary:_address_];
        }
        
        NSMutableArray *propers = [NSMutableArray array];
        NSArray *_properties_ = [dictionary arrayForKey:@"properties"];
        if(_properties_ != nil) {
            for(int i=0; i<_properties_.count; i++) {
                NSDictionary *property = [_properties_ objectAtIndex:i];
                MerchandiseProperty *mProperty = [[MerchandiseProperty alloc] initWithDictionary:property];
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

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [super toDictionary];
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
