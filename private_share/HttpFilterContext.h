//
//  HttpFilterContext.h
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponse.h"

@interface HttpFilterContext : NSObject

@property (nonatomic, strong) HttpResponse *response;

- (instancetype)initWithHttpResponse:(HttpResponse *)response;

@end
