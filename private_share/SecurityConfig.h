//
//  SecurityConfig.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityConfig : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *securityKey;
@property (nonatomic, assign) BOOL isFirstLogin;

+ (instancetype)defaultConfig;

- (BOOL)isLogin;
- (void)saveConfig;
- (void)clearAuthenticationInfo;

@end
