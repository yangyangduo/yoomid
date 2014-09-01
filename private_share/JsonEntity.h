//
//  JsonEntity.h
//  private_share
//
//  Created by Zhao yang on 9/1/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonEntity <NSObject>

- (void)initWithJson:(NSDictionary *)json;
- (NSMutableDictionary *)toJson;

@end
