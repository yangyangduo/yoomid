//
//  UpgradeTask.m
//  private_share
//
//  Created by 曹大为 on 14/9/18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UpgradeTask.h"

@implementation UpgradeTask
@synthesize answer;
@synthesize questionId;
@synthesize question;
@synthesize options;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        NSArray *questions = [json arrayForKey:@"questions"];
        NSDictionary *questionsD = [questions objectAtIndex:0];
        self.answer = [questionsD objectForKey:@"answer"];
        self.question = [questionsD objectForKey:@"question"];
        self.questionId = [questionsD objectForKey:@"questionId"];

        
        NSLog(@"answer:%@",self.answer);
        NSLog(@"question:%@",self.question);
        NSLog(@"question:%@",self.questionId);

    }
    return self;
}

@end
