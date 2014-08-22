//
//  HttpClient.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "HttpClient.h"

static NSTimeInterval const kDefaultTimoutTimeInterval = 10;

@implementation HttpClient {
}

@synthesize baseUrl = _baseUrl_;
@synthesize timeoutInterval = _timeoutInterval_;

@synthesize httpFilters = _httpFilters_;

+ (NSOperationQueue *)requestOperationQueue {
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 2;
    });
    return queue;
}

#pragma mark -
#pragma mark Initializations

+ (instancetype)defaultClient {
    static dispatch_once_t onceToken;
    static HttpClient *client;
    dispatch_once(&onceToken, ^{
        client = [[HttpClient alloc] init];
    });
    return client;
}

- (id)initWithBaseUrl:(NSString *)baseUrl {
    self = [super init];
    if(self) {
        self.baseUrl = baseUrl;
    }
    return self;
}

- (void)get:(NSString *)url target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self execute:url method:@"GET" headers:nil body:nil target:target success:success failure:failure userInfo:userInfo];
}

- (void)post:(NSString *)url contentType:(id)contentType body:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    NSMutableDictionary *headers = nil;
    if(contentType != nil) {
        headers = [[NSMutableDictionary alloc] init];
        [headers setObject:contentType forKey:@"Content-Type"];
    }
    [self execute:url method:@"POST" headers:headers body:body target:target success:success failure:failure userInfo:userInfo];
}

- (void)put:(NSString *)url contentType:(NSString *)contentType body:(NSData *)body target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    NSMutableDictionary *headers = nil;
    if(contentType != nil) {
        headers = [[NSMutableDictionary alloc] init];
        [headers setObject:contentType forKey:@"Content-Type"];
    }
    [self execute:url method:@"PUT" headers:headers body:body target:target success:success failure:failure userInfo:userInfo];
}

- (void)delete:(NSString *)url target:(id)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
    [self execute:url method:@"DELETE" headers:nil body:nil target:target success:success failure:failure userInfo:userInfo];
}

- (void)execute:(NSString *)url method:(NSString *)method headers:(NSDictionary *)hearders body:(NSData *)body target:(NSObject *)target success:(SEL)success failure:(SEL)failure userInfo:(id)userInfo {
#ifdef DEBUG
        NSLog(@"\r\nMethod: %@ \r\nUrl: %@\r\n\r\n", method, url);
#endif

    // new request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self getRequestUrl:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeoutInterval];
    
    // http method
    request.HTTPMethod = method;
    
    // request header
    if(hearders != nil) {
        request.allHTTPHeaderFields = hearders;
    }
    
    // request body
    request.HTTPBody = body;
    
    __weak __typeof(target) wTarget = target;
    [NSURLConnection sendAsynchronousRequest:request queue:[[self class] requestOperationQueue]
                           completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
                               HttpResponse *httpResponse = [[HttpResponse alloc] init];
                               if(error == nil && [resp isKindOfClass:[NSHTTPURLResponse class]]) {
                                   
                                   NSHTTPURLResponse *rp = (NSHTTPURLResponse *)resp;
                                   httpResponse.statusCode = abs((int)rp.statusCode);
                                   httpResponse.userInfo = userInfo;
                                   httpResponse.headers = rp.allHeaderFields;
                                   httpResponse.MIMEType = rp.MIMEType;
                                   httpResponse.contentType = [rp.allHeaderFields valueForKey:@"Content-Type"];
                                   httpResponse.body = data;
#ifdef DEBUG
                                   NSString *bodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"\r\nResponse: %ld \r\nBody: %@\r\n\r\n", (long)rp.statusCode, bodyString);
#endif
                                   
                                   HttpFilterContext *context = [[HttpFilterContext alloc] initWithHttpResponse:httpResponse];
                                   if(![self doFilter:context]) return;
                                   
                                   if(wTarget != nil && success != nil) {
                                       __strong __typeof__(target) sobj = wTarget;
                                       if([sobj respondsToSelector:success]) {
                                           [sobj performSelectorOnMainThread:success withObject:httpResponse waitUntilDone:NO];
                                       }
                                   }
                               } else {
#ifdef DEBUG
                                   NSLog(@"Http client response on error. ");
#endif
                                   if(wTarget != nil && failure != nil) {
                                       __strong __typeof__(target) sobj = wTarget;
                                       if([sobj respondsToSelector:failure]) {
                                           httpResponse.failureReason = error.localizedFailureReason;
                                           httpResponse.userInfo = userInfo;
                                           [sobj performSelectorOnMainThread:failure withObject:httpResponse waitUntilDone:NO];
                                       }
                                   }
                               }
                           }];
}

- (BOOL)doFilter:(HttpFilterContext *)context {
    for(int i=0; i<self.httpFilters.count; i++) {
        id<HttpFilter> filter = [self.httpFilters objectAtIndex:i];
        if([filter filter:context] == NO) {
            return NO;
        }
    }
    return YES;
}

- (NSURL *)getRequestUrl:(NSString *)url {
    if([self isEmpty:_baseUrl_] && [self isEmpty:url]) return nil;
    if([self isEmpty:_baseUrl_]) {
        return [[NSURL alloc] initWithString:url];
    }
    if([self isEmpty:url]) {
        return [[NSURL alloc] initWithString:_baseUrl_];
    }
    if(![url hasPrefix:@"/"]) {
        url = [NSString stringWithFormat:@"/%@", url];
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _baseUrl_, url]];
}

- (void)setBaseUrl:(NSString *)baseUrl {
    if(baseUrl != nil && [baseUrl hasSuffix:@"/"]) {
        _baseUrl_ = [baseUrl substringToIndex:baseUrl.length - 1];
        return;
    }
    _baseUrl_ = baseUrl;
}

- (void)addHttpFilter:(id<HttpFilter>)httpFilter {
    if(httpFilter == nil || httpFilter.identifier == nil) return;
    int foundIndex = -1;
    for(int i=0; i<self.httpFilters.count; i++) {
        id<HttpFilter> _filter_ = [self.httpFilters objectAtIndex:i];
        if([_filter_.identifier isEqualToString:httpFilter.identifier]) {
            foundIndex = i;
            break;
        }
    }
    if(foundIndex == -1) {
        [self.httpFilters addObject:httpFilter];
    } else {
        [self.httpFilters removeObjectAtIndex:foundIndex];
        [self.httpFilters addObject:httpFilter];
    }
}

- (void)removeHttpFilterByIdentifier:(NSString *)identifier {
    if(identifier == nil) return;
    int foundIndex = -1;
    for(int i=0; i<self.httpFilters.count; i++) {
        id<HttpFilter> _filter_ = [self.httpFilters objectAtIndex:i];
        if([_filter_.identifier isEqualToString:identifier]) {
            foundIndex = i;
            break;
        }
    }
    if(foundIndex != -1) {
        [self.httpFilters removeObjectAtIndex:foundIndex];
    }
}

- (void)removeAllHttpFilters {
    [self.httpFilters removeAllObjects];
}

- (NSMutableArray *)httpFilters {
    if(_httpFilters_ == nil) {
        _httpFilters_ = [NSMutableArray array];
    }
    return _httpFilters_;
}

- (NSTimeInterval)timeoutInterval {
    if(_timeoutInterval_ <= 0) {
        return kDefaultTimoutTimeInterval;
    }
    return _timeoutInterval_;
}

- (BOOL)isEmpty:(NSString *)string {
    return string == nil || [@"" isEqualToString:string];
}

@end


