//
//  SecurityConfig.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "SecurityConfig.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

NSString * const kGlobalConfigKey   =   @"global.config.key";
NSString * const kUserNameKey       =   @"global.username.key";
NSString * const kSecurityKeyKey    =   @"global.securitykey.key";
NSString * const kIsFirstLoginKey   =   @"global.isfirstloginkey.key";

@implementation SecurityConfig

@synthesize userName;
@synthesize securityKey;
@synthesize isFirstLogin;

+ (instancetype)defaultConfig {
    static SecurityConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[[self class] alloc] init];
    });
    return config;
}

- (id)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *config = [defaults objectForKey:kGlobalConfigKey];
        if(config == nil) {
            self.userName = @"";
            self.securityKey = @"";
            self.isFirstLogin = YES;
        } else {
            self.userName = [config noNilStringForKey:kUserNameKey];
            self.securityKey = [config noNilStringForKey:kSecurityKeyKey];
            self.isFirstLogin = [config booleanForKey:kIsFirstLoginKey];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setMayBlankString:self.userName forKey:kUserNameKey];
    [dictionary setMayBlankString:self.securityKey forKey:kSecurityKeyKey];
    [dictionary setBoolean:self.isFirstLogin forKey:kIsFirstLoginKey];
    return dictionary;
}

- (void)saveConfigInternal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toDictionary] forKey:kGlobalConfigKey];
    [defaults synchronize];
}

- (void)saveConfig {
    @synchronized(self) {
        [self saveConfigInternal];
    }
}

- (void)clearAuthenticationInfo {
    @synchronized(self) {
        self.userName = @"";
        self.securityKey = @"";
        [self saveConfigInternal];
    }
}

- (BOOL)isLogin {
    if(![XXStringUtils isBlank:self.userName]
              && ![XXStringUtils isBlank:self.securityKey]) {
        return YES;
    }
    return NO;
}

@end
