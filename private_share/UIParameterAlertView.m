//
//  UIParameterAlertView.m
//  private_share
//
//  Created by Zhao yang on 6/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UIParameterAlertView.h"

@implementation UIParameterAlertView {
    NSMutableDictionary *_parameters_;
}

@synthesize identifier;

- (id)parameterForKey:(NSString *)key {
    if(_parameters_ == nil) return nil;
    return [_parameters_ objectForKey:key];
}

- (void)setParameter:(id)parameter forKey:(NSString *)key {
    if(_parameters_ == nil) {
        _parameters_ = [NSMutableDictionary dictionary];
    }
    [_parameters_ setObject:parameter forKey:key];
}

- (void)removeParameterForKey:(NSString *)key {
    if(_parameters_ != nil) {
        [_parameters_ removeObjectForKey:key];
    }
}

@end
