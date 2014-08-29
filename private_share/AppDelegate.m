//
//  AppDelegate.m
//  private_share
//
//  Created by Zhao yang on 5/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AppDelegate.h"
#import "UINavigationViewInitializer.h"
#import "ViewControllerAccessor.h"
#import "LoginViewController.h"
#import "GlobalConfig.h"
#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "Constants.h"
#import "ShoppingCart.h"
#import <Escore/YJFUserMessage.h>
#import <Escore/YJFInitServer.h>
#import <AdSupport/ASIdentifierManager.h>
#import "PunchBoxAd.h"
#import "Account.h"
#import "GuideViewController.h"
#import "MiidiManager.h"
#import "MiidiAdWall.h"
#import "HomePageViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /*
    // Configure drawer view controller's defaut appearance
    [DrawerViewController defaultConfig].leftDrawerViewVisibleWidth = 235;
    [DrawerViewController defaultConfig].triggerHideLeftDrawerViewX = 175;
    [DrawerViewController defaultConfig].rightDrawerViewVisibleWidth = self.window.bounds.size.width - 44;
    
    // Center view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HomePageViewController alloc] init]];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    
    // Left view controller
    LeftDrawerViewController *leftDrawerViewController = [[LeftDrawerViewController alloc] init];
    
    // Drawer View Controller with left and center view controller
    DrawerViewController *drawerViewController = [[DrawerViewController alloc] initWithLeftViewController:leftDrawerViewController rightViewController:[[MyPointsRecordViewController alloc] init] centerViewController:navigationController];
    
    //
    [ViewControllerAccessor defaultAccessor].drawerViewController = drawerViewController;
    
    self.window.rootViewController = drawerViewController;
    [self.window makeKeyAndVisible];
    */
    
    HomePageViewController *homeViewController = [[HomePageViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    if(![GlobalConfig defaultConfig].isLogin) {
        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
        [homeViewController presentViewController:loginNavigationViewController animated:NO completion:^{ }];
        //[loginNavigationViewController presentViewController:[[GuideViewController alloc] init] animated:NO completion:^{ }];
    } else {
        [self doAfterLogin];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Login and logout

- (void)doAfterLogin {
    if([GlobalConfig defaultConfig].isLogin) {
        // init ad platforms
        [self initAdPlatforms];
        //
        [Account currentAccount].accountId = [GlobalConfig defaultConfig].userName;
        [[Account currentAccount] refreshPoints];
    }
}

- (void)doAfterLoginWithUserName:(NSString *)userName securityKey:(NSString *)securityKey {
    [GlobalConfig defaultConfig].userName = userName;
    [GlobalConfig defaultConfig].securityKey = securityKey;
    [[GlobalConfig defaultConfig] saveConfig];
    [self doAfterLogin];
}

- (void)doAfterLogout {
    [self clearUserInfo];
}

- (void)clearUserInfo {
    [self clearUserInfoButShoppingCart];
    [[ShoppingCart myShoppingCart] clearMyShoppingCart];
}

- (void)clearUserInfoButShoppingCart {
    [[ShoppingCart myShoppingCart] clearContactInfo];
    [[GlobalConfig defaultConfig] clearAuthenticationInfo];
    [[Account currentAccount] clear];
}

- (BOOL)checkLogin {
    if(![GlobalConfig defaultConfig].isLogin) {
        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
        [[ViewControllerAccessor defaultAccessor].drawerViewController presentViewController:loginNavigationViewController animated:YES completion:^{ }];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Ad platforms initialization

- (void)initAdPlatforms {
    
    // init youmi platform
    [YouMiConfig setUserID:[GlobalConfig defaultConfig].userName];
    [YouMiConfig launchWithAppID:kYoumiAppID appSecret:kYoumiSecretKey];
    [YouMiWall enable];
    
//    init yijifen platform disabled
//    [YJFUserMessage shareInstance].yjfCoop_info = [GlobalConfig defaultConfig].userName;
//    [YJFUserMessage shareInstance].yjfUserAppId = kYijifenAppID;
//    [YJFUserMessage shareInstance].yjfUserDevId = kYijifenDeveloperID;
//    [YJFUserMessage shareInstance].yjfAppKey = kYijifenSecretKey;
//    [YJFUserMessage shareInstance].yjfChannel = kYijifenChannel;
//    YJFInitServer *InitData = [[YJFInitServer alloc] init];
//    [InitData getInitEscoreData];
    
    // init cocounion platform
    [PunchBoxAd startSession:kCocounionSecretKey];
    [PunchBoxAd setUserInfo:[GlobalConfig defaultConfig].userName];
    
    // init miidi adwall
    [MiidiManager setAppPublisher:kMiidiAppId withAppSecret:kMiidiAppSecretKey];
    [MiidiAdWall setUserParam:[GlobalConfig defaultConfig].userName];
}

#pragma mark -
#pragma mark Top view controller

- (UIViewController *)topViewController {
    DrawerViewController *drawerViewController = [ViewControllerAccessor defaultAccessor].drawerViewController;
    if(drawerViewController != nil) {
        UIViewController *centerViewController = drawerViewController.centerViewController;
        return [self topViewController:centerViewController];
    }
    return nil;
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if(rootViewController == nil) return nil;
    
    UIViewController *controller =
    rootViewController.presentedViewController == nil ? rootViewController : rootViewController.presentedViewController;
    
    if([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationViewController = (UINavigationController *)controller;
        UIViewController *viewController = [navigationViewController.viewControllers lastObject];
        if(viewController == nil) return navigationViewController;
        return [self topViewController:viewController];
    } else if([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)controller;
        if(tabBarController.selectedViewController == nil) return tabBarController;
        [self topViewController:tabBarController.selectedViewController];
    }
    
    if(controller.presentedViewController == nil) {
        return controller;
    }
    
    return [self topViewController:controller.presentedViewController];
}

@end
