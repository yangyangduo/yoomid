//
//  HttpClient.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponse.h"
#import "HttpFilter.h"

@interface HttpClient : NSObject

@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) NSMutableArray *httpFilters;

+ (instancetype)defaultClient;

- (id)initWithBaseUrl:(NSString *)baseUrl;

- (void)get:(NSString *)url target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

- (void)post:(NSString *)url contentType:(id)contentType body:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

- (void)put:(NSString *)url contentType:(NSString *)contentType body:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;

- (void)delete:(NSString *)url target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo;


- (void)removeAllHttpFilters;
- (void)removeHttpFilterByIdentifier:(NSString *)identifier;
- (void)addHttpFilter:(id<HttpFilter>)httpFilter;

@end
