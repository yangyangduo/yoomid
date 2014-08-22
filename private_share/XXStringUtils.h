//
//  XXStringUtils.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXStringUtils : NSObject

+ (NSString *)emptyString;

+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isBlank:(NSString *)str;

+ (NSString *)trim:(NSString *)str;

+ (BOOL)string:(NSString *)s1 isEqualString:(NSString *)s2;
+ (NSString *)noNilStringWithString:(NSString *)str;

+ (NSString *)stringEncodeWithBase64:(NSString *)str;
+ (NSString *)md5HexDigest:(NSString *)str;

@end