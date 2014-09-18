//
//  UpgradeTask.m
//  private_share
//
//  Created by 曹大为 on 14/9/18.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UpgradeTask.h"
#import "AnswerOptions.h"

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

        NSMutableArray *options_ = [NSMutableArray array];
        NSArray *_options_ = [questionsD arrayForKey:@"options"];
        if (_options_ != nil) {
            for (int i = 0; i<_options_.count; i++) {
                NSDictionary *optionD = [_options_ objectAtIndex:i];
                AnswerOptions *answerOptions = [[AnswerOptions alloc]initWithJson:optionD];
                [options_ addObject:answerOptions];
            }
        }
        self.options = options_;
        NSLog(@"answer:%@",self.answer);
        NSLog(@"question:%@",self.question);
        NSLog(@"question:%@",self.questionId);
        NSLog(@"options:%@",self.options);
    }
    return self;
}

@end
