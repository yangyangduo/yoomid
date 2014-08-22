//
//  DateTimeUtil.m
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DateTimeUtil.h"

@implementation DateTimeUtil

+ (BOOL)dateTime:(NSDate *)dateTime isExpiredAfter:(NSTimeInterval)expiredSeconds {
    if(dateTime == nil) return YES;
    NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:dateTime];
    return timeDifference > expiredSeconds;
}

@end
