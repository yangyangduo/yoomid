//
//  AnswerOptions.m
//  private_share
//
//  Created by 曹大为 on 14/9/18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AnswerOptions.h"

@implementation AnswerOptions
@synthesize description;
@synthesize option;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.description = [json noNilStringForKey:@"description"];
        self.option = [json noNilStringForKey:@"option"];
    }
    return  self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.description forKey:@"description"];
    [json setMayBlankString:self.option forKey:@"option"];
    return json;
}
@end
