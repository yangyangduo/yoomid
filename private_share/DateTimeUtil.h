//
//  DateTimeUtil.h
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeUtil : NSObject

+ (BOOL)dateTime:(NSDate *)dateTime isExpiredAfter:(NSTimeInterval)expiredSeconds;

@end
