//
//  GlobalConfig.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConfig : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *securityKey;

+ (instancetype)defaultConfig;

- (BOOL)isLogin;
- (void)saveConfig;
- (void)clearAuthenticationInfo;

@end
