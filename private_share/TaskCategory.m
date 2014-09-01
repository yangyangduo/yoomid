//
//  TaskCategory.m
//  private_share
//
//  Created by Zhao yang on 9/1/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TaskCategory.h"

@implementation TaskCategory

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.parentCategory = [json noNilStringForKey:@"parentCategory"];
        self.displayName = [json noNilStringForKey:@"displayName"];
        self.description = [json noNilStringForKey:@"description"];
        
        NSNumber *_required_user_level_ = [json numberForKey:@"requiredUserLevel"];
        self.requiredUserLevel = _required_user_level_ == nil ? 0 : _required_user_level_.integerValue;
        
        self.isActive = [json booleanForKey:@"active"];
        self.hasParent = [json booleanForKey:@"parent"];
        self.isLocked = [json booleanForKey:@"locked"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    [json setMayBlankString:self.identifier forKey:@"id"];
    [json setMayBlankString:self.parentCategory forKey:@"parentCategory"];
    [json setMayBlankString:self.displayName forKey:@"displayName"];
    [json setMayBlankString:self.description forKey:@"description"];
    [json setInteger:self.requiredUserLevel forKey:@"requiredUserLevel"];
    [json setBoolean:self.isActive forKey:@"active"];
    [json setBoolean:self.hasParent forKey:@"parent"];
    [json setBoolean:self.isLocked forKey:@"locked"];
    
    return json;
}

@end
