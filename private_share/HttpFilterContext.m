//
//  HttpFilterContext.m
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "HttpFilterContext.h"

@implementation HttpFilterContext

@synthesize response = _response_;

- (instancetype)initWithHttpResponse:(HttpResponse *)response {
    self = [super init];
    if(self) {
        _response_ = response;
    }
    return self;
}

@end
