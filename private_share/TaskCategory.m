//
//  TaskCategory.m
//  private_share
//
//  Created by Zhao yang on 9/1/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TaskCategory.h"

@implementation TaskCategory

@synthesize identifier = _identifier_;

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

- (NSString *)iconName {
    if(TaskCategoryTypeProductExperience == self.taskCategoryType) {
        return @"product_experience";
    } else if(TaskCategoryTypeGuessPicture == self.taskCategoryType) {
        return @"guess_picture";
    } else if(TaskCategoryTypeSurvey == self.taskCategoryType) {
        return @"survey";
    } else if(TaskCategoryTypeGame == self.taskCategoryType) {
        return @"";
    } else if(TaskCategoryTypeSocialSharing == self.taskCategoryType) {
        return @"social_sharing";
    } else {
        return nil;
    }
}

- (void)setIdentifier:(NSString *)identifier {
    _identifier_ = identifier;
    if(_identifier_ == nil) {
        self.taskCategoryType = TaskCategoryTypeUnknow;
        return;
    }
    
    if([@"y:e:ap" isEqualToString:_identifier_]) {
        self.taskCategoryType = TaskCategoryTypeProductExperience;
    } else if([@"y:i:gp" isEqualToString:_identifier_]) {
        self.taskCategoryType = TaskCategoryTypeGuessPicture;
    } else if([@"y:i:sv" isEqualToString:_identifier_]) {
        self.taskCategoryType = TaskCategoryTypeSurvey;
    } else if([@"y:i:gm" isEqualToString:_identifier_]) {
        self.taskCategoryType = TaskCategoryTypeGame;
    } else if([@"y:i:sc" isEqualToString:_identifier_]) {
        self.taskCategoryType = TaskCategoryTypeSocialSharing;
    } else {
        self.taskCategoryType = TaskCategoryTypeUnknow;
    }
}

@end
