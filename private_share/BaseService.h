//
//  BaseService.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonUtil.h"
#import "XXStringUtils.h"
#import "GlobalConfig.h"
#import "HttpClient.h"
#import "Constants.h"

@interface BaseService : NSObject

@property (nonatomic, strong, readonly) NSString *authenticationString;

- (HttpClient *)httpClient;
- (NSString *)dataToString:(NSData *)data;
- (NSString *)authenticationString;

@end
