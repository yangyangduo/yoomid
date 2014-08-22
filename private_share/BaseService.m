//
//  BaseService.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseService.h"
#import "HttpResponseAuthorizationFilter.h"

@implementation BaseService

- (instancetype)init {
    self = [super init];
    if(self) {
        [HttpClient defaultClient].baseUrl = kBaseUrl;
        [[HttpClient defaultClient] addHttpFilter:[[HttpResponseAuthorizationFilter alloc] init]];
    }
    return self;
}

- (HttpClient *)httpClient {
    return [HttpClient defaultClient];
}

- (NSString *)authenticationString {
    return [NSString stringWithFormat:@"loginAccount=%@&account=%@&securityKey=%@",[GlobalConfig defaultConfig].userName, [GlobalConfig defaultConfig].userName, [GlobalConfig defaultConfig].securityKey];
};

- (NSString *)dataToString:(NSData *)data {
    if(data == nil) return nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
