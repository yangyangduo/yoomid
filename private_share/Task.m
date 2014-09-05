//
//  Task.m
//  private_share
//
//  Created by Zhao yang on 9/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.name = [json noNilStringForKey:@"name"];
        self.provider = [json noNilStringForKey:@"provider"];
        
        NSNumber *levelNumber = [json numberForKey:@"requiredUserLevel"];
        self.requiredUserLevel = (levelNumber == nil ? 0 : levelNumber.integerValue);
        
        NSNumber *pointsNumber = [json numberForKey:@"points"];
        self.points = (pointsNumber == nil ? 0 : pointsNumber.integerValue);
        
        NSNumber *timeLimitNumber = [json numberForKey:@"timeLimitInSeconds"];
        self.timeLimitInSeconds = (timeLimitNumber == nil ? 0 : timeLimitNumber.integerValue);
        
        self.taskDescriptionUrl = [json noNilStringForKey:@"taskDescriptionUrl"];
    }
    return self;
}

- (BOOL)isGuessPictureTask {
    if(self.categoryId == nil) return NO;
    return [@"y:i:gp" isEqualToString:self.categoryId];
}

@end
