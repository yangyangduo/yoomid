//
//  HttpFilter.h
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpFilterContext.h"

@protocol HttpFilter <NSObject>

@optional

- (NSString *)filterName;

@required

- (NSString *)identifier;
- (BOOL)filter:(HttpFilterContext *)context;

@end
