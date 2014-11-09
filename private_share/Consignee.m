//
//  Consignee.m
//  private_share
//
//  Created by 曹大为 on 14/11/7.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "Consignee.h"

@implementation Consignee
- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        
        self.identifier = [json noNilStringForKey:@"id"];
        self.name  = [json noNilStringForKey:@"name"];
        self.phoneNumber = [json noNilStringForKey:@"contactPhone"];
        self.address = [json noNilStringForKey:@"deliveryAddress"];
        self.isDefault = [json noNilStringForKey:@"isDefault"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.identifier forKey:@"id"];
    [json setMayBlankString:self.name forKey:@"name"];
    [json setMayBlankString:self.phoneNumber forKey:@"contactPhone"];
    [json setMayBlankString:self.address forKey:@"deliveryAddress"];
    [json setMayBlankString:self.isDefault forKey:@"isDefault"];
    return json;
}

- (BOOL)isEmpty {
    return self.identifier == nil;
}

@end
