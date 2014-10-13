//
//  AppDelegate.m
//  private_share
//
//  Created by Zhao yang on 5/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "GuideViewController.h"
#import "ViewControllerAccessor.h"
#import "UINavigationViewInitializer.h"
#import "UMessage.h"

#import "Account.h"
#import "SecurityConfig.h"
#import "Constants.h"
#import "ShoppingCart.h"
#import "DiskCacheManager.h"

#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "MiidiManager.h"
#import "MiidiAdWall.h"
#import "PunchBoxAd.h"

#import "MobClick.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialData.h"
#import "UMSocialQQHandler.h"
#import "UMSocialInstagramHandler.h"
#import "UMSocialSnsService.h"

@implementation AppDelegate


//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initUMAnalytics];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    [UMessage startWithAppkey:@"54052fe0fd98c5170d06988e" launchOptions:launchOptions];
//    //(iOS 8.0以下)
//    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//     |UIRemoteNotificationTypeSound
//     |UIRemoteNotificationTypeAlert];
//    
//    [UMessage setLogEnabled:YES];
//    [UMSocialData openLog:YES];
    [WXApi registerApp:@"wxb3bc53583590b23f"];
    
    [UMSocialData setAppKey:@"54052fe0fd98c5170d06988e"];
    
    [UMSocialWechatHandler setWXAppId:@"wxb3bc53583590b23f" appSecret:@"a39d046b07684bab942b68e709ae137b" url:@"http://yoomid.com"];
    [UMSocialQQHandler setQQWithAppId:@"1102346164" appKey:@"T4tsAiwGE3oZNBVf" url:@"http://yoomid.com"];
    [UMSocialQQHandler setSupportWebView:YES];
//    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
    
//    [WXApi registerApp:@"wxb3bc53583590b23f"];

    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [ViewControllerAccessor defaultAccessor].homeViewController = homeViewController;

    if(![SecurityConfig defaultConfig].isLogin) {
        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
        [homeViewController presentViewController:loginNavigationViewController animated:NO completion:^{ }];
        if ([SecurityConfig defaultConfig].isFirstLogin) {
                    [loginNavigationViewController presentViewController:[[GuideViewController alloc] init] animated:NO completion:^{ }];
        }
    } else {
        [self doAfterLogin];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];//友盟分享
    if (result == FALSE) {
        return [WXApi handleOpenURL:url delegate:self];//微信支付
    }
    return result;
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                [[XXAlertView currentAlertView] setMessage:@"支付成功!" forType:AlertViewTypeSuccess];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
                
                [[self topViewController] viewWillAppear:YES];
                break;
                case WXErrCodeUserCancel:
                [[XXAlertView currentAlertView] setMessage:@"支付取消!" forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
                break;
            default:
                [[XXAlertView currentAlertView] setMessage:resp.errStr forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
                break;
        }
    }
}


//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    [UMessage registerDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [UMessage didReceiveRemoteNotification:userInfo];
//    NSLog(@"userInfo:%@",userInfo);
//}

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
    if([SecurityConfig defaultConfig].isLogin) {
        [self initAdPlatforms];
        [Account currentAccount].accountId = [SecurityConfig defaultConfig].userName;
        [[Account currentAccount] refresh];
        [[DiskCacheManager manager] serveForAccount:[SecurityConfig defaultConfig].userName];
    }
}

- (void)doAfterLoginWithUserName:(NSString *)userName securityKey:(NSString *)securityKey isFirstLogin:(BOOL)isFirstLogin {
    [SecurityConfig defaultConfig].userName = userName;
    [SecurityConfig defaultConfig].securityKey = securityKey;
    [SecurityConfig defaultConfig].isFirstLogin = isFirstLogin;
    [[SecurityConfig defaultConfig] saveConfig];
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
    [[SecurityConfig defaultConfig] clearAuthenticationInfo];
    [[Account currentAccount] clear];
}

- (BOOL)checkLogin {
    if(![SecurityConfig defaultConfig].isLogin) {
        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
        [[ViewControllerAccessor defaultAccessor].homeViewController presentViewController:loginNavigationViewController animated:YES completion:^{ }];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Ad platforms initialization

- (void)initAdPlatforms {
    // init youmi platform
    [YouMiConfig setUserID:[SecurityConfig defaultConfig].userName];
    [YouMiConfig launchWithAppID:kYoumiAppID appSecret:kYoumiSecretKey];
    [YouMiWall enable];
    
    /*
    // init cocounion platform
    [PunchBoxAd startSession:kCocounionSecretKey];
    [PunchBoxAd setUserInfo:[SecurityConfig defaultConfig].userName];
    
    // init miidi adwall
    [MiidiManager setAppPublisher:kMiidiAppId withAppSecret:kMiidiAppSecretKey];
    [MiidiAdWall setUserParam:[SecurityConfig defaultConfig].userName];
     */
}

#pragma mark -
#pragma mark uMeng initalization

- (void)initUMAnalytics {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [MobClick startWithAppkey:kUMengAppKey reportPolicy:BATCH channelId:@"Web"];
    [MobClick setAppVersion:version];
}

#pragma mark -
#pragma mark Top view controller

- (UIViewController *)topViewController {
    return [self topViewController:[ViewControllerAccessor defaultAccessor].homeViewController];
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
