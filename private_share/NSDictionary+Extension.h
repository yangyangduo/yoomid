//
//  NSDictionary+Extension.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXStringUtils.h"

@interface NSDictionary (Extension)

- (id)notNSNullObjectForKey:(id)key;

// DEPRECATED
- (BOOL)boolForKey:(id)key __attribute__((deprecated));

- (BOOL)booleanForKey:(id)key;

- (NSString *)stringForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;


- (NSDate *)dateWithTimeIntervalSince1970ForKey:(id)key;

// 用毫秒
- (NSDate *)dateWithMillisecondsForKey:(id)key;
- (int)intForKey:(id)key;
- (long)longForKey:(id)key;
- (long long)longlongForKey:(id)key;
- (double)doubleForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSString *)noNilStringForKey:(id)key;

@end

