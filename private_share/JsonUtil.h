//
//  JsonUtil.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtil : NSObject

+ (id)createDictionaryOrArrayFromJsonData:(NSData *)jsonData;

+ (NSData *)createJsonDataFromDictionary:(NSDictionary *)dictionary;
+ (NSData *)createJsonDataFromArray:(NSArray *)array;

+ (void)printJsonData:(NSData *)data;

+ (void)printDictionaryAsJsonFormat:(NSDictionary *)dictionary;
+ (void)printArrayAsJsonFormat:(NSArray *)array;

@end
