//
//  AppDelegate.h
//  private_share
//
//  Created by Zhao yang on 5/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)checkLogin;

- (void)doAfterLogout;
- (void)doAfterLogin;
- (void)doAfterLoginWithUserName:(NSString *)userName securityKey:(NSString *)securityKey;

- (UIViewController *)topViewController;

- (void)clearUserInfo;
- (void)clearUserInfoButShoppingCart;

@end
