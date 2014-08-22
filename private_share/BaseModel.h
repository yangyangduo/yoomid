//
//  BaseModel.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

@interface BaseModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)toDictionary;

@end
